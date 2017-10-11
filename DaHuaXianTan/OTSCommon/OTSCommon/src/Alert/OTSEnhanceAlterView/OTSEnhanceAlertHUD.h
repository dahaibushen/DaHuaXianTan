//
//  OTSEnhanceAlertHUD.h
//  OneStoreFramework
//
//  Created by ChaiJun on 15/8/31.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTSEnhanceAlertHUDDelegate.h"
#import "OTSEnhanceAlterView.h"

@interface OTSEnhanceAlertHUD : NSObject

/**
 *  show alert
 *
 *  @param title             title,暂时只支持设置字体颜色
 *  @param message           message,暂时只支持设置字体颜色
 *  @param delegate          回调对象
 *  @param cancelButtonTitle 取消按钮
 *  @param otherButtonTitles 其他按钮
 *
 *  @return <#return value description#>
 */
+ (OTSEnhanceAlterView *)showWithTitle:(NSAttributedString *)title
                       message:(NSAttributedString *)message
                      delegate:(id /*<OTSEnhanceAlertHUDDelegate>*/)delegate
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
