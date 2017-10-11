//
//  YHDWebView.h
//  OTSService
//
//  Created by liuwei7 on 2017/8/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHDWebView : UIWebView <UIWebViewDelegate>

- (NSString *)executeJS:(NSString *)js;

+ (void)setCookie:(NSString *)aDomain name:(NSString *)aName value:(NSString *)aValue;

@end
