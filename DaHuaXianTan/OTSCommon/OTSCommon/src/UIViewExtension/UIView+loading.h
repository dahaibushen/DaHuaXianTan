//
//  UIView+loading.h
//  OneStoreFramework
//
//  Created by Aimy on 14/10/30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (loading)

/**
 *  功能:显示loading
 */
- (void)showLoading;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second;

- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second isModal:(BOOL)isModal;

/**
 *  功能:隐藏loading
 */
- (void)hideLoading;

@end
