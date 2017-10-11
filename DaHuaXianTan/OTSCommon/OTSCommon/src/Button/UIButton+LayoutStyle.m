//
//  UIButton+LayoutStyle.m
//  OTSCore
//
//  Created by Jerry on 2017/8/24.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "UIButton+LayoutStyle.h"
#import "NSObject+Runtime.h"

static NSString *const layoutStyleKey = @"ots_button_layout_style";
static NSString *const layoutPaddingKey = @"ots_button_layout_padding";
static NSString *const layoutSpacingKey = @"ots_button_layout_spacing";

@implementation UIButton (LayoutStyle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeMethod:@selector(intrinsicContentSize) withMethod:@selector(OTS_UIButton_LayoutStyle_intrinsicContentSize)];
        [self exchangeMethod:@selector(sizeThatFits:) withMethod:@selector(OTS_UIButton_LayoutStyle_sizeThatFits:)];
    });
}

- (CGSize)OTS_UIButton_LayoutStyle_sizeThatFits:(CGSize)size {
    if (self.layoutStyle == OTSButtonLayoutImageTop || self.layoutStyle == OTSButtonLayoutImageBottom) {
        CGFloat imageWidth = self.imageView.intrinsicContentSize.width;
        CGFloat titleWidth = self.titleLabel.intrinsicContentSize.width;
        CGFloat imageHeight = self.imageView.intrinsicContentSize.height;
        CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;

        CGFloat width = MAX(imageWidth, titleWidth) + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
        CGFloat height = imageHeight + titleHeight + self.layoutSpacing + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
        return CGSizeMake(width, height);
    }
    CGSize mSize = [self OTS_UIButton_LayoutStyle_sizeThatFits:size];
    if (self.layoutSpacing != 0) {
        mSize.width += self.layoutSpacing;
    }
    return mSize;
}

- (CGSize)OTS_UIButton_LayoutStyle_intrinsicContentSize {
    if (self.layoutStyle == OTSButtonLayoutImageTop || self.layoutStyle == OTSButtonLayoutImageBottom) {
        CGFloat imageWidth = self.imageView.intrinsicContentSize.width;
        CGFloat titleWidth = self.titleLabel.intrinsicContentSize.width;
        CGFloat imageHeight = self.imageView.intrinsicContentSize.height;
        CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;

        CGFloat width = MAX(imageWidth, titleWidth) + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
        CGFloat height = imageHeight + titleHeight + self.layoutSpacing + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
        return CGSizeMake(width, height);
    }

    CGSize mSize = [self OTS_UIButton_LayoutStyle_intrinsicContentSize];
    if (self.layoutSpacing != 0) {
        mSize.width += self.layoutSpacing;
    }
    return mSize;
}

#pragma mark - API

- (void)setLayout:(OTSButtonLayout)layout spacing:(CGFloat)spacing {
    [self setAssociatedObject:@(layout) forKey:layoutStyleKey policy:OTSAssociationPolicyRetainNonatomic];
    [self setAssociatedObject:@(spacing) forKey:layoutSpacingKey policy:OTSAssociationPolicyRetainNonatomic];
    [self updateButtonInsets];
}

- (void)updateButtonInsets {
    CGFloat padding = self.layoutPadding;
    CGFloat offset = self.layoutSpacing;
    CGFloat halfOffset = offset * 0.5;

    if (padding > 0) {
        self.contentEdgeInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
    }

    CGFloat imageWidth = self.imageView.intrinsicContentSize.width;
    CGFloat titleWidth = self.titleLabel.intrinsicContentSize.width;


    switch (self.layoutStyle) {

        case OTSButtonLayoutDefault: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, halfOffset, 0, -halfOffset);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -halfOffset, 0, 0);
            break;
        }

        case OTSButtonLayoutImageRight: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - halfOffset, 0, imageWidth + halfOffset);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth + halfOffset, 0, -titleWidth - halfOffset);
            break;
        }

        case OTSButtonLayoutImageTop: {
            CGFloat imageHeight = self.imageView.intrinsicContentSize.height;
            CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;

            self.titleEdgeInsets = UIEdgeInsetsMake(imageHeight + halfOffset, -imageWidth, 0, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(-titleHeight * 0.5 - halfOffset, 0, titleHeight * 0.5 + halfOffset, 0);

            break;
        }

        case OTSButtonLayoutImageBottom: {
            CGFloat imageHeight = self.imageView.intrinsicContentSize.height;
            CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;

            self.titleEdgeInsets = UIEdgeInsetsMake(-imageHeight * 0.5 - halfOffset, -imageWidth, imageHeight * 0.5 + halfOffset, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(titleHeight + halfOffset, 0, 0, 0);

            break;
        }

    }

    [self invalidateIntrinsicContentSize];
}

#pragma mark - Getter & Setter

- (OTSButtonLayout)layoutStyle {
    return [[self getAssociatedObjectForKey:layoutStyleKey] integerValue];
}

- (void)setLayoutStyle:(OTSButtonLayout)layoutStyle {
    [self setAssociatedObject:@(layoutStyle) forKey:layoutStyleKey policy:OTSAssociationPolicyRetainNonatomic];
    [self updateButtonInsets];
}

- (CGFloat)layoutSpacing {
    return [[self getAssociatedObjectForKey:layoutSpacingKey] floatValue];
}

- (void)setLayoutSpacing:(CGFloat)layoutSpacing {
    [self setAssociatedObject:@(layoutSpacing) forKey:layoutSpacingKey policy:OTSAssociationPolicyRetainNonatomic];
    [self updateButtonInsets];
}

- (CGFloat)layoutPadding {
    return [[self getAssociatedObjectForKey:layoutPaddingKey] floatValue];
}

- (void)setLayoutPadding:(CGFloat)layoutPadding {
    [self setAssociatedObject:@(layoutPadding) forKey:layoutPaddingKey policy:OTSAssociationPolicyRetainNonatomic];
    [self updateButtonInsets];
}

@end
