//
//  UIView+create.h
//  OneStoreFramework
//
//  Created by Aimy on 14-7-14.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

//#import <PureLayout/PureLayout.h>
#import <UIKit/UIKit.h>

@interface UIView (create)

/**
 *  快捷创建UIView及其子类
 *
 *
 *  @return kind of UIView
 */
+ (instancetype)createWithNib;

/**
 *  生成一个frame = CGRectZero的 View，并设置translatesAutoresizingMaskIntoConstraints = NO
 *  backgroundcolor=[uicolor clear]
 *  @return view
 */
+ (instancetype)autolayoutView;

@end
