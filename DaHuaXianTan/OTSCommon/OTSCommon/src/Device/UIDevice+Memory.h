//
//  UIDevice+Memory.h
//  OTSKit
//
//  Created by Jerry on 2017/1/2.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Memory)

@property(nonatomic, readonly) double availableMemory;
@property(nonatomic, readonly) double usedMemory;

@end

NS_ASSUME_NONNULL_END
