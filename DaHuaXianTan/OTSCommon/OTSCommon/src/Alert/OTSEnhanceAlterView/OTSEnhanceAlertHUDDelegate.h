//
//  OTSEnhanceAlertHUDDelegate.h
//  OneStoreFramework
//
//  Created by ChaiJun on 15/8/31.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTSEnhanceAlterView;
@protocol OTSEnhanceAlertHUDDelegate <NSObject>

- (void)bmAlertView:(OTSEnhanceAlterView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
