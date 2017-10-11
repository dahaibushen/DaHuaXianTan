//
//  NSObject+DeallocPromise.h
//  OTSCore
//
//  Created by Jerry on 2017/9/25.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "OTSPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DeallocPromise)

- (OTSPromise*)willDeallocate;//promise with nil

@end

NS_ASSUME_NONNULL_END
