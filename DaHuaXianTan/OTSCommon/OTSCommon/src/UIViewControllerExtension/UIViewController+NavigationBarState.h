//
//  UIViewController+NavigationBarState.h
//  OTSCore
//
//  Created by Jerry on 2017/8/21.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NavigationBarState)

//stash current navigation bar attribute
- (void)stashNavigationBarAttribute;

//restore stashed navigation bar attribute
- (void)restoreNavigationBarAttribute;
- (void)removeStashedNavigationBarAttribute;

/**
 * @brief transparent navigation bar with different styles. bar background image, bar tint color and shadow image will be cleared.
 *       if fillImage is set, we will transparent the given fillImage. Otherwise, fillColor will be transparented.
 *       we will try to stash the current navigation bar state if it has not been stashed.
 
 * @param barStyle use UIBarStyleDefault when status bar content is dark and UIBarStyleBlack when light
 * @param fillImage bar background image, set to nil if pure color is used
 * @param fillColor bar background color, will be ignored if fillImage is set
 * @param tintColor bar tint color. If nil, we will set bar tint color white when barStyle is UIBarStyleBlack and light gray when UIBarStyleDefault
 * @param transparency fill image or color will be transparent by transparency
 */
- (void)setNavigationBarStyle:(UIBarStyle)barStyle
              backgroundImage:(nullable UIImage*)fillImage
                    fillColor:(nullable UIColor*)fillColor
                    tintColor:(nullable UIColor*)tintColor
                 transparency:(CGFloat)transparency;

@end

NS_ASSUME_NONNULL_END
