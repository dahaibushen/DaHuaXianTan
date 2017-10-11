//
//  UIScrollView+PullRefresh.m
//  OneStoreLight
//
//  Created by Jerry on 16/8/31.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIScrollView+PullRefresh.h"
//#import "NSObject+Runtime.h"
//#import "NSObject+FBKVOController.h"
//#import "UIView+Frame.h"
//#import "OTSCoreMacros.h"

@implementation UIScrollView (PullRefresh)

#pragma mark - Public
//- (void)addRefreshHeaderWithBlock:(OTSRefreshHeaderBlock)aBlock contentClass:(Class)contentClass {
//    OTSRefreshHeaderView *headerView = [[OTSRefreshHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, .0) refreshingBlock:aBlock contentViewClass:contentClass];
//    WEAK_SELF;
//    [self.KVOController observe:headerView keyPath:@"state" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
//        STRONG_SELF;
//        OTSPullRefreshState newState = [change[NSKeyValueChangeNewKey] integerValue];
//        if (newState == OTSPullRefreshStateRefreshing) {
//            [self.refreshFooter endRefreshing];
//        }
//    }];
//    
//    self.refreshHeader = headerView;
//}

- (void)addLoadMoreFooterWithBlock:(id)aBlock contentClass:(Class)contentClass {
//    OTSRefreshFooterView *footerView = [[OTSRefreshFooterView alloc] initWithFrame:CGRectMake(0, 0, self.width, .0) refreshingBlock:aBlock contentViewClass:contentClass];
//    self.refreshFooter = footerView;
}

//- (void)triggerRefreshing {
//    [self.refreshHeader startRefreshing];
//}
//
//- (void)headerActionError:(NSString*)errorMsg {
//    if (self.refreshHeader.state == OTSPullRefreshStateRefreshing) {
//        [self.refreshHeader pauseRefreshing];
//    }
//    if ([self.refreshHeader.contentView respondsToSelector:@selector(loadedError:)]) {
//        [self.refreshHeader.contentView loadedError:errorMsg];
//    }
//}
//
//- (void)footerActionError:(NSString*)errorMsg {
//    if (self.refreshFooter.state == OTSPullRefreshStateRefreshing) {
//        [self.refreshFooter pauseRefreshing];
//    }
//    if ([self.refreshFooter.contentView respondsToSelector:@selector(loadedError:)]) {
//        [self.refreshFooter.contentView loadedError:errorMsg];
//    }
//}
//
//- (void)footerActionPause:(NSString*)pauseMsg {
//    if (self.refreshFooter.state == OTSPullRefreshStateRefreshing) {
//        [self.refreshFooter pauseRefreshing];
//    }
//    self.refreshFooter.hidden = false;
//    if ([self.refreshFooter.contentView respondsToSelector:@selector(loadedPause:)]) {
//        [self.refreshFooter.contentView loadedPause:pauseMsg];
//    }
//}
//
//- (void)headerActionSuccessfully {
//    if (self.refreshHeader.state != OTSPullRefreshStateIdle) {
//        if ([self.refreshHeader.contentView respondsToSelector:@selector(loadedSuccess)]) {
//            [self.refreshHeader.contentView loadedSuccess];
//            [self.refreshHeader endRefreshingWithDelay:.6];
//        } else {
//            [self.refreshHeader endRefreshing];
//        }
//    }
//}
//
//- (void)footerActionSuccessfully {
//    if (self.refreshFooter.state != OTSPullRefreshStateIdle) {
//        [self.refreshHeader endRefreshing];
//        self.refreshFooter.hidden = true;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.refreshFooter endRefreshing];
//        });
//    }
//}
//
//static NSString *OTS_REFRESH_HEADER_KEY = @"ots_refresh_header";
//static NSString *OTS_REFRESH_FOOTER_KEY = @"ots_refresh_footer";
//
//#pragma mark - Getter & Setter
//- (OTSRefreshHeaderView*)refreshHeader {
//    return [self getAssociatedObjectForKey:OTS_REFRESH_HEADER_KEY];
//}
//
//- (void)setRefreshHeader:(OTSRefreshHeaderView *)refreshHeader {
//    if (self.refreshHeader) {
//        [self.refreshHeader removeFromSuperview];
//    }
//    if (refreshHeader) {
//        [self addSubview:refreshHeader];
//    }
//    [self setAssociatedObject:refreshHeader forKey:OTS_REFRESH_HEADER_KEY policy:OTSAssociationPolicyRetainNonatomic];
//}
//
//- (OTSRefreshFooterView*)refreshFooter {
//    return [self getAssociatedObjectForKey:OTS_REFRESH_FOOTER_KEY];
//}
//
//- (void)setRefreshFooter:(OTSRefreshFooterView *)refreshFooter {
//    if (self.refreshFooter) {
//        [self.refreshFooter removeFromSuperview];
//    }
//    if (refreshFooter) {
//        [self addSubview:refreshFooter];
//    }
//    [self setAssociatedObject:refreshFooter forKey:OTS_REFRESH_FOOTER_KEY policy:OTSAssociationPolicyRetainNonatomic];
//}

@end
