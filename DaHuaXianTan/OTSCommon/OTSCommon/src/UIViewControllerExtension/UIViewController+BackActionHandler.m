//
//  UIViewController+BackActionHandler.m
//  OTSKit
//
//  Created by Jerry on 16/9/23.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIViewController+BackActionHandler.h"
#import "NSObject+Runtime.h"

@implementation UIViewController (BackActionHandler)

@end

NSString *const kOriginDelegate = @"kOriginDelegate";

@implementation UINavigationController (ShouldPopOnBackAction)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeMethod:@selector(viewDidLoad) withMethod:@selector(new_viewDidLoad)];
    });
}

- (void)new_viewDidLoad {
    [self new_viewDidLoad];
    
    objc_setAssociatedObject(self, [kOriginDelegate UTF8String], self.interactivePopGestureRecognizer.delegate, OBJC_ASSOCIATION_ASSIGN);
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if([self.viewControllers count] < [navigationBar.items count]) {
        return true;
    }
    
    BOOL shouldPop = true;
    UIViewController* vc = self.topViewController;
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButtonClicked)]) {
        shouldPop = [vc navigationShouldPopOnBackButtonClicked];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:true];
        });
    } else {
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return false;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count <= 1) {
            return false;
        }
        UIViewController *vc = self.topViewController;
        if([vc respondsToSelector:@selector(navigationShouldPopOnBackButtonClicked)]) {
            return [vc navigationShouldPopOnBackButtonClicked];
        }
        id<UIGestureRecognizerDelegate> originDelegate = objc_getAssociatedObject(self, [kOriginDelegate UTF8String]);
        return [originDelegate gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return YES;
    }
    return NO;
}

@end
