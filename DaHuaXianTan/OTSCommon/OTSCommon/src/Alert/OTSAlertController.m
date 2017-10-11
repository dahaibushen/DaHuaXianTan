//
//  OTSAlertController.m
//  OneStoreBase
//
//  Created by Jiang on 16/12/5.
//  Copyright © 2016年 OneStoreBase. All rights reserved.
//

#import "OTSAlertController.h"

#import "RACEXTScope.h"

@interface OTSAlertController ()

@property(nonatomic, copy) OTSAlertControllerBlock block;

@end

@implementation OTSAlertController

+ (OTSAlertController *)alertWithMessage:(NSString *)message
                        andCompleteBlock:(OTSAlertControllerBlock)completeBlock {

    return [self alertWithTitle:nil message:message
               andCompleteBlock:completeBlock];
}

+ (OTSAlertController *)alertWithTitle:(NSString *)title
                               message:(NSString *)message
                      andCompleteBlock:(OTSAlertControllerBlock)completeBlock {

    return [self alertWithTitle:title message:message leftButtonTitle:@"确定" rightButtonTitle:nil andCompleteBlock:completeBlock];
}

+ (OTSAlertController *)alertWithTitle:(NSString *)title
                               message:(NSString *)message
                       leftButtonTitle:(NSString *)leftButtonTitle
                      rightButtonTitle:(NSString *)rightButtonTitle
                      andCompleteBlock:(OTSAlertControllerBlock)completeBlock {
    NSAssert((!title) || [title isKindOfClass:[NSString class]], @"title 类型不对!");
    NSAssert((!message) || [message isKindOfClass:[NSString class]], @"message类型不对!");
    NSAssert((!leftButtonTitle) || [leftButtonTitle isKindOfClass:[NSString class]], @"title 类型不对!");
    NSAssert((!rightButtonTitle) || [rightButtonTitle isKindOfClass:[NSString class]], @"message类型不对!");

    if (title && ![title isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (message && ![message isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (leftButtonTitle && ![leftButtonTitle isKindOfClass:[NSString class]]) {
        leftButtonTitle = nil;
    }
    if (!leftButtonTitle) {
        leftButtonTitle = @"确定";
    }
    if (rightButtonTitle && ![rightButtonTitle isKindOfClass:[NSString class]]) {
        return nil;
    }

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.1 && title == nil && message != nil) {//iOS 8的设备 如果只有 message 没有 title 会导致 message的提示 顶在顶部,不居中,比较丑陋
        title = message;
        message = nil;
    }
    OTSAlertController *alertController = [OTSAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    if (leftButtonTitle) {
        @weakify(alertController);
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:leftButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            @strongify(alertController);
            if (completeBlock) {
                completeBlock(alertController, 0);
            }
        }];
        [alertController addAction:cancelButton];
    }

    if (rightButtonTitle) {
        @weakify(alertController);
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:rightButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            @strongify(alertController);
            if (completeBlock) {
                completeBlock(alertController, 1);
            }
        }];
        [alertController addAction:okButton];
    }
    [[[OTSAlertController window] rootViewController] presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

+ (UIWindow *)window {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window == nil) {
        if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
            window = [[UIApplication sharedApplication].delegate window];
        }
    }
    return window;
}

@end
