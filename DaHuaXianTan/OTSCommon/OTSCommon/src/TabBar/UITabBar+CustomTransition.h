//
//  UITabBar+CustomTransition
//  OTSCore
//
//  Created by Jerry on 2017/8/22.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//在自定义动画过程中，tabbar是没有办法被自定义的，会默认从左往右有一个push动作
//这个category可以干预这种动作，默认动作改为从上往下 custom action is supported if set.

@interface UITabBar (CustomTransition)

@property(nonatomic, strong, null_resettable) id <CAAction> customShowAction;
@property(nonatomic, strong, null_resettable) id <CAAction> customHideAction;

@end

NS_ASSUME_NONNULL_END
