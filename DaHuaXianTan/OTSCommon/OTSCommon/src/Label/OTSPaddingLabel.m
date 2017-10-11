//
//  OTSPaddingLabel.m
//  OneStoreBase
//
//  Created by Jerry on 16/8/8.
//  Copyright © 2016年 OneStoreBase. All rights reserved.
//

#import "OTSPaddingLabel.h"

@implementation OTSPaddingLabel

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentInsets, contentInsets)) {
        _contentInsets = contentInsets;
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentInsets)];
}

- (CGSize)intrinsicContentSize {
    if (self.text.length > 0) {
        CGSize size = [super intrinsicContentSize];
        size.width += self.contentInsets.left + self.contentInsets.right;
        size.height += self.contentInsets.top + self.contentInsets.bottom;
        return size;
    }
    return CGSizeZero;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

@end
