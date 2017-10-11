//
//  UIButton+LayoutStyle.h
//  OTSCore
//
//  Created by Jerry on 2017/8/24.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OTSButtonLayout) {
    OTSButtonLayoutDefault,     //image left and text right
    OTSButtonLayoutImageRight,  //text left and image right
    OTSButtonLayoutImageTop,    //image top and text bottom
    OTSButtonLayoutImageBottom, //image bottom and text top
};

@interface UIButton (LayoutStyle)

//default is OTSButtonLayoutDefault. It will change titleEdgeInsets and imageEdgeInsets
@property(nonatomic, assign) IBInspectable OTSButtonLayout layoutStyle;

//spacing bewteen text and image. default is 0. Must be greater than 0. It will change titleEdgeInsets and imageEdgeInsets
@property(nonatomic, assign) IBInspectable CGFloat layoutSpacing;

//default is 0. It will change contentEdgeInsets.
@property(nonatomic, assign) IBInspectable CGFloat layoutPadding;

//force the button to recalculate its titleEdgeInsets, imageEdgeInsets and contentEdgeInsets
- (void)updateButtonInsets;

- (void)setLayout:(OTSButtonLayout)layout spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
