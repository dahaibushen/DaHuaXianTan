//
//  OTSRefreshFooterView.h
//  OneStoreLight
//
//  Created by Jerry on 16/8/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSRefreshContentViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class OTSRefreshFooterView;

typedef void (^OTSRefreshFooterBlock)(OTSRefreshFooterView *refreshView);

@interface OTSRefreshFooterView : UIView

@property(nonatomic, strong) Class contentViewClass;

@property(nonatomic, assign, readonly) OTSPullRefreshState state;
@property(nonatomic, strong, readonly) UIView <OTSRefreshContentViewProtocol> *contentView;

@property(nonatomic, assign) CGFloat preFetchedDistance;

@property(nonatomic, copy, nullable) OTSRefreshFooterBlock refreshingBlock;

- (instancetype)initWithFrame:(CGRect)frame
              refreshingBlock:(OTSRefreshFooterBlock)refreshingBlock
             contentViewClass:(Class)contentViewClass;

- (void)endRefreshing;

- (void)pauseRefreshing;

@end

NS_ASSUME_NONNULL_END
