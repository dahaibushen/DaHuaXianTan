//
//  UIViewController+BackActionHandler.h
//  OTSKit
//
//  Created by Jerry on 16/9/23.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackActionHandlerProtocol <NSObject>

@optional
-(BOOL)navigationShouldPopOnBackButtonClicked;

@end

@interface UIViewController (BackActionHandler)<BackActionHandlerProtocol>

@end
