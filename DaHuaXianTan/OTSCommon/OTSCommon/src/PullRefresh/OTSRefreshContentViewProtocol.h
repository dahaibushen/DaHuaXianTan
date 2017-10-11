//
//  OTSRefreshContentViewProtocol.h
//  JWUIKit
//
//  Created by Jerry on 16/4/11.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#ifndef OTSRefreshContentViewProtocol_h
#define OTSRefreshContentViewProtocol_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OTSPullRefreshState) {
    OTSPullRefreshStateIdle,
    OTSPullRefreshStateRefreshing,
    OTSPullRefreshStatePause
};

@protocol OTSRefreshContentViewProtocol <NSObject>

+ (CGFloat)preferredHeight;

@optional
- (void)setProgress:(CGFloat)progress;

- (void)startLoading;

- (void)stopLoading;

- (void)loadedSuccess;

- (void)loadedError:(NSString*)errorMsg;

- (void)loadedPause:(NSString*)pauseMsg;

@end

#endif /* OTSRefreshContentViewProtocol_h */
