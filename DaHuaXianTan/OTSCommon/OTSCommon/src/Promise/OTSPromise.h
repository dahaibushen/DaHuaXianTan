//
//  OTSPromise.h
//  OTSKit
//
//  Created by Jerry on 2017/8/9.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^OTSPromiseFulfillBlock)(id value);

typedef void (^OTSPromiseErrorBlock)(NSError *anError);

typedef void (^OTSPromiseFinallyBlock)(id value, NSError *anError);

typedef NS_ENUM(NSInteger, OTSPromiseStatus) {
    OTSPromiseStatusPending,
    OTSPromiseStatusResolved,
    OTSPromiseStatusRejected
};

@interface OTSPromise : NSObject

@property(nonatomic, readonly, assign) OTSPromiseStatus status;

@property(nonatomic, readonly) OTSPromise *(^then)(OTSPromiseFulfillBlock);
@property(nonatomic, readonly) OTSPromise *(^catch)(OTSPromiseErrorBlock);

- (BOOL)resolve:(id)value;

- (BOOL)reject:(NSError *)anError;

+ (instancetype)reject:(NSError *)error;

+ (instancetype)resolve:(id)value;

//直到最后一个promise执行完成，才返回，参见ES6 promise
+ (instancetype)all:(NSArray<OTSPromise *> *)promises;

//只要有一个promise执行完成，就立即返回。其他promise仍然会被执行，参见ES6 promise
+ (instancetype)race:(NSArray<OTSPromise *> *)promises;

@end

@interface OTSPromise ()

//finally最后一定会执行，ES6 promise标准中没有finally，为扩展方法
@property(nonatomic, readonly) void (^finally)(OTSPromiseFinallyBlock);

+ (instancetype)timeout:(NSTimeInterval)interval;

@end
