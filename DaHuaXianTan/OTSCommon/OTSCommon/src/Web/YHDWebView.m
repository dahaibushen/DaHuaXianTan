//
//  YHDWebView.m
//  OTSService
//
//  Created by liuwei7 on 2017/8/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "YHDWebView.h"

@implementation YHDWebView

#pragma mark - Excute JS
- (NSString *)executeJS:(NSString *)js
{
    if (js.length == 0) {
        return nil;
    }
    
    __block NSString *ret = nil;
    
    if (![NSThread currentThread].isMainThread) {
        __block BOOL isFinishedExecuteJS = NO;
        __weak YHDWebView *weakSelf = (id)self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ret = [weakSelf tryExecuteJS:js];
            isFinishedExecuteJS = YES;
        });

        while (!isFinishedExecuteJS) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    } else {
        ret = [self tryExecuteJS:js];
    }
    
    return ret;
}

- (NSString *)tryExecuteJS:(NSString *)js
{
    NSString *ret = nil;
    @try {
        ret = [self stringByEvaluatingJavaScriptFromString:js];
    } @catch(NSException *e) {
        //log exception
    }
    
    return ret;
}

#pragma mark - Cookies
+ (void)setCookie:(NSString *)aDomain name:(NSString *)aName value:(NSString *)aValue
{
    if (!aName) {
        return ;
    }
    
    if (!aValue) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies.copy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSHTTPCookie *cookie = obj;
            if ([cookie.properties[NSHTTPCookieName] isEqualToString:aName]) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
                *stop = YES;
            }
        }];
        
        return ;
    }
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    cookieProperties[NSHTTPCookieDomain] = aDomain;
    cookieProperties[NSHTTPCookieName] = aName;
    cookieProperties[NSHTTPCookieValue] = aValue;
    cookieProperties[NSHTTPCookiePath] = @"/";
    cookieProperties[NSHTTPCookieVersion] = @"0";
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

@end
