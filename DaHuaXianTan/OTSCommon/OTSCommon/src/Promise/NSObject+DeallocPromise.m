//
//  NSObject+DeallocPromise.m
//  OTSCore
//
//  Created by Jerry on 2017/9/25.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "NSObject+DeallocPromise.h"
#import "NSObject+Runtime.h"

static NSString *const OTSObjectDeallocObserverKey = @"OTSObjectDeallocObserverKey";

@interface OTSObjectDeallocObserver : NSObject

@property (nonatomic, strong) OTSPromise *promise;
@property (nonatomic, weak) NSObject *owner;

- (instancetype)initWithOwner:(NSObject*)owner;

@end

@implementation NSObject (DeallocPromise)

- (OTSPromise*)willDeallocate {
    OTSObjectDeallocObserver *observer = [self getAssociatedObjectForKey:OTSObjectDeallocObserverKey];
    if (!observer) {
        observer = [[OTSObjectDeallocObserver alloc] initWithOwner:self];
    }
    return observer.promise;
}

@end

@implementation OTSObjectDeallocObserver

- (instancetype)initWithOwner:(NSObject*)owner {
    if (self = [super init]) {
        _promise = [OTSPromise new];
        _owner = owner;
        [_owner setAssociatedObject:self
                             forKey:OTSObjectDeallocObserverKey
                             policy:OTSAssociationPolicyRetainNonatomic];
    }
    return self;
}

- (void)dealloc {
    if (_promise) {
        [_promise resolve:nil];
    }
    _promise = nil;
}

@end
