//
//  OTSEnlargeButton.m
//  OneStoreBase
//
//  Created by tianwangkuan on 27/04/2017.
//  Copyright © 2017 OneStoreBase. All rights reserved.
//

#import "OTSEnlargeButton.h"

@implementation OTSEnlargeButton

@dynamic enlargeEdge;
@synthesize enlargeAreaOutsets = _enlargeAreaOutsets;

- (void)setEnlargeEdge:(CGFloat)enlargeEdge {
    self.enlargeAreaOutsets = UIEdgeInsetsMake(enlargeEdge, enlargeEdge, enlargeEdge, enlargeEdge);
}

- (CGFloat)enlargeEdge {
    return self.enlargeAreaOutsets.top;
}

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {
    self.enlargeAreaOutsets = UIEdgeInsetsMake(top, left, bottom, right);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL enlargeAreaDisabled = UIEdgeInsetsEqualToEdgeInsets(self.enlargeAreaOutsets, UIEdgeInsetsZero);
    if (self.hidden == YES || self.alpha <= 0 || enlargeAreaDisabled) {
        return [super hitTest:point withEvent:event];
    }

    CGRect rect = self.bounds;
    UIEdgeInsets outset = self.enlargeAreaOutsets;
    CGRect enlargeArea = CGRectMake(rect.origin.x - outset.left,
            rect.origin.y - outset.top,
            rect.size.width + outset.left + outset.right,
            rect.size.height + outset.top + outset.bottom);
    return CGRectContainsPoint(enlargeArea, point) ? self : nil;
}

@end
