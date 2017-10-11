//
//  JWRefreshHeaderView.h
//  JWUIKit
//
//  Created by Jerry on 16/4/8.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSRefreshContentViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class OTSRefreshHeaderView;

typedef void (^OTSRefreshHeaderBlock)(OTSRefreshHeaderView *refreshView);

typedef NS_ENUM(NSInteger, OTSPullRefreshStyle) {
    OTSPullRefreshStyleStill,
    OTSPullRefreshStyleFollow
};

@interface OTSRefreshHeaderView : UIView

@property (nonatomic, assign) OTSPullRefreshStyle style;
@property (nonatomic, strong) Class contentViewClass;

@property (nonatomic, assign, readonly) OTSPullRefreshState state;
@property (nonatomic, strong, readonly) UIView<OTSRefreshContentViewProtocol> *contentView;

@property (nonatomic, copy, nullable) OTSRefreshHeaderBlock refreshingBlock;

- (instancetype)initWithFrame:(CGRect)frame
              refreshingBlock:(OTSRefreshHeaderBlock)refreshingBlock
             contentViewClass:(Class)contentViewClass;

- (void)startRefreshing;

- (void)endRefreshing;
- (void)endRefreshingWithDelay:(NSTimeInterval)delay;

- (void)pauseRefreshing;

@end

NS_ASSUME_NONNULL_END
