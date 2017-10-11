//
//  OTSEnlargeButton.h
//  OneStoreBase
//
//  Created by tianwangkuan on 27/04/2017.
//  Copyright © 2017 OneStoreBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSEnlargeButton : UIButton

@property(assign, nonatomic) UIEdgeInsets enlargeAreaOutsets;

/**
 *  设置需要扩大的范围, 上下左右各扩大的范围
 */
@property(assign, nonatomic) IBInspectable CGFloat enlargeEdge;

/**
 *  设置需要扩大的范围
 *
 *  @param top    上边
 *  @param right  右边
 *  @param bottom 底边
 *  @param left   左边
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
