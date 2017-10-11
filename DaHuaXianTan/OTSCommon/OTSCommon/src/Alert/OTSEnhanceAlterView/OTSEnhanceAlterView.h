//
//  OTSEnhanceAlterView.h
//  OneStoreFramework
//
//  Created by ChaiJun on 15/8/31.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <OTSCore/UIView+Frame.h>
#import "UIView+Frame.h"

@class OTSEnhanceAlterView;
@protocol OTSEnhanceAlertViewDelegate <NSObject>

- (void)bmAlertView:(OTSEnhanceAlterView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface OTSEnhanceAlterView : UIView

- (instancetype)initWithTitle:(NSAttributedString *)title
                      message:(NSAttributedString *)message
                     delegate:(id /*<OTSEnhanceAlertHUDDelegate>*/)delegate
                       titles:(NSArray *)titles;
@end
