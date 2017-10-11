//
//  UIViewController+NavigationBarState.m
//  OTSCore
//
//  Created by Jerry on 2017/8/21.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "UIViewController+NavigationBarState.h"
#import "NSObject+Runtime.h"
#import "UIImage+Color.h"

NSString *const OTSNavigationBarUtilityKey = @"OTSNavigationBarUtilityKey";

@implementation UIViewController (NavigationBarState)

- (void)stashNavigationBarAttribute {
    if (!self.navigationController) {
        return;
    }
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    UINavigationBar *bar = self.navigationController.navigationBar;
    
    [attribute setObject:@(bar.translucent) forKey:@"translucent"];
    [attribute setObject:(bar.tintColor ?: [NSNull null]) forKey:@"tintColor"];
    [attribute setObject:(bar.barTintColor ?: [NSNull null]) forKey:@"barTintColor"];
    [attribute setObject:@(bar.barStyle) forKey:@"barStyle"];
    [attribute setObject:(bar.shadowImage ?: [NSNull null]) forKey:@"shadowImage"];
    [attribute setObject:(bar.titleTextAttributes ?: [NSNull null]) forKey:@"titleTextAttributes"];
    [attribute setObject:@(bar.alpha) forKey:@"alpha"];
    [attribute setObject:@(bar.hidden) forKey:@"hidden"];
    
    UIImage *backgroundImage = [bar backgroundImageForBarMetrics:UIBarMetricsDefault];
    [attribute setObject:(backgroundImage ?: [NSNull null]) forKey:@"backgroundImage"];
    
    [self setAssociatedObject:attribute forKey:OTSNavigationBarUtilityKey policy:OTSAssociationPolicyRetainNonatomic];
}

- (void)restoreNavigationBarAttribute {
    if (!self.navigationController) {
        return;
    }
    
    NSDictionary *attribute = [self getAssociatedObjectForKey:OTSNavigationBarUtilityKey];
    if (attribute) {
        UINavigationBar *bar = self.navigationController.navigationBar;
        [attribute enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            id value = (obj == [NSNull null] ? nil : obj);
            if ([key isEqualToString:@"backgroundImage"]) {
                [bar setBackgroundImage:value forBarMetrics:UIBarMetricsDefault];
            } else {
                [bar setValue:value forKey:key];
            }
        }];
    }
}

- (void)removeStashedNavigationBarAttribute {
    [self removeAssociatedObjectForKey:OTSNavigationBarUtilityKey];
}

- (void)setNavigationBarStyle:(UIBarStyle)barStyle
              backgroundImage:(UIImage*)fillImage
                    fillColor:(UIColor*)mfillColor
                    tintColor:(UIColor*)tintColor
                 transparency:(CGFloat)transparency {
    if (!self.navigationController) {
        return;
    }
    
    NSDictionary *attribute = [self getAssociatedObjectForKey:OTSNavigationBarUtilityKey];
    if (!attribute) {
        [self stashNavigationBarAttribute];
    }
    
    
    UIImage *backgroundImage = nil;
    if (fillImage) {
        backgroundImage = [fillImage imageByApplyingAlpha:transparency];
    } else {
        UIColor *fillColor = mfillColor;
        if (!fillColor) {
            fillColor = [UIColor clearColor];
        } else {
            fillColor = [fillColor colorWithAlphaComponent:transparency];
        }
        backgroundImage = [UIImage imageWithColor:fillColor];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithWhite:.0 alpha:.0]]];
    
    BOOL contentAboveBarShouldBeLight = barStyle == UIBarStyleBlack;
    if (!tintColor) {
        tintColor = contentAboveBarShouldBeLight ? [UIColor whiteColor] : [UIColor colorWithWhite:.2 alpha:1.0];
    }
    
    self.navigationController.navigationBar.barStyle = (contentAboveBarShouldBeLight ? UIBarStyleBlack : UIBarStyleDefault);
    self.navigationController.navigationBar.tintColor = tintColor;
    
    NSDictionary *titleAttr = @{NSForegroundColorAttributeName : tintColor,NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttr];
}

@end
