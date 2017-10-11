//
//  OTSAlertController.h
//  OneStoreBase
//
//  Created by Jiang on 16/12/5.
//  Copyright © 2016年 OneStoreBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTSAlertController;

/**
 *  alertController点击按钮之后的回调block
 *
 *  @param alertController   对象
 *  @param buttonIndex 点击的button的序号，从0开始
 */
typedef void(^OTSAlertControllerBlock)(OTSAlertController *alertController, NSInteger buttonIndex);

@interface OTSAlertController : UIAlertController

/**
 *  弹框alertController（默认有一个标题为确定的按钮）
 *
 *  @param message 内容
 *  @param completeBlock   回调block
 *
 *  @return OTSAlertController
 */
+ (OTSAlertController *)alertWithMessage:(NSString *)message
                        andCompleteBlock:(OTSAlertControllerBlock)completeBlock;

/**
 *  弹框alertController（默认有一个标题为确定的按钮）
 *
 *  @param title   标题
 *  @param message 内容
 *  @param completeBlock   回调block
 *
 *  @return OTSAlertController
 */
+ (OTSAlertController *)alertWithTitle:(NSString *)title
                               message:(NSString *)message
                      andCompleteBlock:(OTSAlertControllerBlock)completeBlock;

/**
 *  弹框alertController
 *
 *  @param title       标题
 *  @param message     内容
 *  @param leftButtonTitle  左按钮标题
 *  @param rightButtonTitle 右按钮标题
 *  @param completeBlock       回调block
 *
 *  @return OTSAlertController
 */
+ (OTSAlertController *)alertWithTitle:(NSString *)title
                               message:(NSString *)message
                       leftButtonTitle:(NSString *)leftButtonTitle
                      rightButtonTitle:(NSString *)rightButtonTitle
                      andCompleteBlock:(OTSAlertControllerBlock)completeBlock;

@end
