//
//  OTSPromise.m
//  OTSKit
//
//  Created by Jerry on 2017/8/9.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSPromise.h"
#import <stdatomic.h>

typedef NS_ENUM(NSUInteger, OTSPromiseStrategy) {
    OTSPromiseStrategyAll,
    OTSPromiseStrategyRace
};

@interface OTSPromise ()

@property(nonatomic, assign) OTSPromiseStatus status;
@property(nonatomic, strong) OTSPromise *root;

@property(nonatomic, copy) OTSPromiseErrorBlock errorBlock;
@property(nonatomic, copy) OTSPromiseFinallyBlock finalBlock;

@property(nonatomic, strong) NSMutableArray<OTSPromiseFulfillBlock> *fullfillQueue;
@property(nonatomic, strong) NSLock *ioLock;

@property(nonatomic, strong) id rawValue;

@end

@implementation OTSPromise

@synthesize then = _then;
@synthesize catch = _catch;
@synthesize finally = _finally;

+ (instancetype)reject:(NSError *)error {
    OTSPromise *promise = [[OTSPromise alloc] init];
    [promise reject:error];
    return promise;
}

+ (instancetype)resolve:(id)value {
    OTSPromise *promise = [[OTSPromise alloc] init];
    [promise resolve:value];
    return promise;
}

+ (instancetype)timeout:(NSTimeInterval)interval {
    OTSPromise *promise = [[OTSPromise alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [promise resolve:nil];
    });
    return promise;
}

+ (instancetype)all:(NSArray<OTSPromise *> *)promises {
    return [self group:promises strategy:OTSPromiseStrategyAll];
}

+ (instancetype)race:(NSArray<OTSPromise *> *)promises {
    return [self group:promises strategy:OTSPromiseStrategyRace];
}

- (BOOL)reject:(NSError *)anError {
    if (self.status != OTSPromiseStatusPending) {
        return false;
    }
    self.rawValue = anError;
    self.status = OTSPromiseStatusRejected;
    return [self emit];
}

- (BOOL)resolve:(id)value {
    if (self.status != OTSPromiseStatusPending) {
        return false;
    }
    self.rawValue = value;
    self.status = OTSPromiseStatusResolved;
    return [self emit];
}

#pragma mark - Private Functions

- (BOOL)emit {
    BOOL invalid = false;
    OTSPromise *rootPromise = self.root ?: self;

    if (self.status == OTSPromiseStatusRejected) {

        [self.ioLock lock];
        !rootPromise.errorBlock ?: rootPromise.errorBlock(self.rawValue);
        [self.ioLock unlock];

        if (rootPromise.finalBlock) {
            rootPromise.finalBlock(nil, self.rawValue);
        }

    } else if (self.status == OTSPromiseStatusResolved) {
        [self.ioLock lock];
        OTSPromiseFulfillBlock fullfillBlock = rootPromise.fullfillQueue.firstObject;
        if (fullfillBlock) {
            [rootPromise.fullfillQueue removeObjectAtIndex:0];
            id result = fullfillBlock(self.rawValue);
            OTSPromise *child = nil;
            if ([result isKindOfClass:[OTSPromise class]]) {
                child = result;
            } else {
                child = [OTSPromise resolve:result];
            }
            child.root = rootPromise;
            [child emit];
        }
        [self.ioLock unlock];

        if (!fullfillBlock && rootPromise.finalBlock) {
            rootPromise.finalBlock(self.rawValue, nil);
        }
    } else {
        invalid = YES;
    }
    return !invalid;
}

+ (instancetype)group:(NSArray<OTSPromise *> *)promises strategy:(OTSPromiseStrategy)strategy {
    NSParameterAssert(promises.count);

    OTSPromise *promise = [[OTSPromise alloc] init];


    __block atomic_int completeCount = 0;
    __block atomic_int resolvedCount = 0;

    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithCapacity:promises.count];
    NSMutableDictionary *errorDict = [NSMutableDictionary dictionaryWithCapacity:promises.count];
    
    NSUInteger groupCount = promises.count;

    void (^checkShouldEmit)(BOOL resolved) = ^(BOOL resolved) {
        atomic_fetch_add_explicit(&completeCount, 1, memory_order_seq_cst);
        if (resolved) {
            atomic_fetch_add_explicit(&resolvedCount, 1, memory_order_seq_cst);
        }

        if (strategy == OTSPromiseStrategyAll) {
            if (completeCount != groupCount) {
                return;
            }

            BOOL groupResolved = resolvedCount == groupCount;
            
            NSDictionary *valueDict = groupResolved ? dataDict : errorDict;
            NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:completeCount];
            for (int i = 0; i < completeCount; i++) {
                [dataArray addObject:(valueDict[@(i)] ?: [NSNull null])];
            }
            
            if (groupResolved) {
                [promise resolve:dataArray.copy];
            } else {
                [promise reject:dataArray.firstObject];
            }

        } else if (strategy == OTSPromiseStrategyRace) {
            if (completeCount > 1) {
                return;
            }
            if (resolved) {
                [promise resolve:dataDict.allValues.firstObject];
            } else {
                [promise reject:errorDict.allValues.firstObject];
            }
        }
    };

    [promises enumerateObjectsUsingBlock:^(OTSPromise *obj, NSUInteger idx, BOOL *stop) {
        obj.then(^id(id value) {
            dataDict[@(idx)] = value ?: [NSNull null];
            checkShouldEmit(YES);
            return nil;
        }).catch(^(NSError *anError) {
            errorDict[@(idx)] = anError ?: [NSNull null];
            checkShouldEmit(NO);
        });
    }];

    return promise;
}

#pragma mark - Getter & Setter

- (NSMutableArray<OTSPromiseFulfillBlock> *)fullfillQueue {
    if (!_fullfillQueue) {
        _fullfillQueue = [NSMutableArray array];
    }
    return _fullfillQueue;
}

- (NSLock *)ioLock {
    if (!_ioLock) {
        _ioLock = [[NSLock alloc] init];
    }
    return _ioLock;
}

- (OTSPromise *(^)(OTSPromiseFulfillBlock))then {
    if (!_then) {
        __weak typeof(self) weakSelf = self;
        _then = (id) ^(OTSPromiseFulfillBlock fulfill) {
            __strong typeof(weakSelf) self = weakSelf;
            [self.ioLock lock];
            [self.fullfillQueue addObject:fulfill];
            [self.ioLock unlock];
            if (self.status == OTSPromiseStatusResolved) {
                [self emit];
            }
            return self;
        };
    }
    return _then;
}

- (OTSPromise *(^)(OTSPromiseErrorBlock))catch {
    if (!_catch) {
        __weak typeof(self) weakSelf = self;
        _catch = (id) ^(OTSPromiseErrorBlock error) {
            __strong typeof(weakSelf) self = weakSelf;
            [self.ioLock lock];
            self.errorBlock = error;
            [self.ioLock unlock];
            if (self.status == OTSPromiseStatusRejected) {
                [self emit];
            }
            return self;
        };
    }
    return _catch;
}

- (void (^)(OTSPromiseFinallyBlock))finally {
    if (!_finally) {
        __weak typeof(self) weakSelf = self;
        _finally = ^(OTSPromiseFinallyBlock final) {
            __strong typeof(weakSelf) self = weakSelf;
            [self.ioLock lock];
            self.finalBlock = final;
            [self.ioLock unlock];
        };
    }
    return _finally;
}

@end
