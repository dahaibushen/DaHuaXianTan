//
//  UIScrollView+AddRefresh.h
//  OTSCommon
//
//  Created by HU on 2017/10/11.
//  Copyright © 2017年 HU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (AddRefresh)
- (void)addaddLoadMoreFooterWithBlock:(id)aBlock contentClass:(Class)contentClass;
@end
