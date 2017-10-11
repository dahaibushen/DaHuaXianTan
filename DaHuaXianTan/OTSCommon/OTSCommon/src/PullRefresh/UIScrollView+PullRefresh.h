//
//  UIScrollView+PullRefresh.h
//  OneStoreLight
//
//  Created by Jerry on 16/8/31.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSRefreshHeaderView.h"
#import "OTSRefreshFooterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (PullRefresh)

@property (nonatomic, strong, nullable) OTSRefreshHeaderView *refreshHeader;
@property (nonatomic, strong, nullable) OTSRefreshFooterView *refreshFooter;

//content class should confirm to OTSRefreshContentViewProtocol
- (void)addRefreshHeaderWithBlock:(OTSRefreshHeaderBlock)aBlock contentClass:(Class)contentClass;
- (void)addLoadMoreFooterWithBlock:(OTSRefreshFooterBlock)aBlock contentClass:(Class)contentClass;

- (void)triggerRefreshing;

- (void)headerActionSuccessfully;
- (void)footerActionSuccessfully;

- (void)headerActionError:(NSString*)errorMsg;
- (void)footerActionError:(NSString*)errorMsg;

- (void)footerActionPause:(NSString*)pauseMsg;

@end

NS_ASSUME_NONNULL_END
