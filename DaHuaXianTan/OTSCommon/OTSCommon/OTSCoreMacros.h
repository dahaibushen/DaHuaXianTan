//
//  OTSCoreMacros.h
//  OTSCore
//
//  Created by Jerry on 2017/8/2.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#ifndef OTSCoreMacros_h
#define OTSCoreMacros_h

//weak strong self for retain cycle
#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf

//单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (instancetype)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (instancetype)sharedInstance { \
    static dispatch_once_t once; \
    static __class * __singleton__; \
    dispatch_once(&once, ^{\
        __singleton__ = [[__class alloc] init];\
    });\
    return __singleton__; \
}

//log
#ifdef DEBUG
    #define OTSLog(format, ...) NSLog((@"%s@%d: " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define OTSLog(format, ...)
#endif

#define OTSFuncLog OTSLog(@"[%@ call %@]", [self class], NSStringFromSelector(_cmd))

//remove perform selector leak warning
#define OTSSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* OTSCoreMacros_h */

