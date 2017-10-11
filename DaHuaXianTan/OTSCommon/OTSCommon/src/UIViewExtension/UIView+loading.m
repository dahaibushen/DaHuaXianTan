//
//  UIView+loading.m
//  OneStoreFramework
//
//  Created by Aimy on 14/10/30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "UIView+loading.h"
#import "MBProgressHUD.h"
#import "NSObject+Runtime.h"

@implementation UIView (loading)

NSString *const OTSHudViewKey = @"OTSHudViewKey";

- (void)showLoading {
    [self showLoadingWithMessage:nil];
}

- (void)showLoadingWithMessage:(NSString *)message {
    [self showLoadingWithMessage:message hideAfter:0];
}

- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second {
    [self showLoadingWithMessage:message hideAfter:second isModal:YES];
}

- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second isModal:(BOOL)isModal {
    [self hideLoading];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    if (message) {
        hud.label.text = message;
        hud.mode = MBProgressHUDModeText;
    } else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    
    if (second > 0) {
        [hud hideAnimated:true afterDelay:second];
    } else {
        [self setAssociatedObject:hud forKey:OTSHudViewKey policy:OTSAssociationPolicyRetainNonatomic];
    }
    hud.userInteractionEnabled = isModal;
}

- (void)hideLoading {
    MBProgressHUD *hud = [self getAssociatedObjectForKey:OTSHudViewKey];
    if (hud) {
        [hud hideAnimated:true];
        [self removeAssociatedObjectForKey:OTSHudViewKey];
    }
}

@end
