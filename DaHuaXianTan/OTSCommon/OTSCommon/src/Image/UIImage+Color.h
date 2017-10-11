//
//  UIImage+Color.h
//  OTSCore
//
//  Created by Jerry on 2017/8/21.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)aColor;

+ (UIImage *)imageWithColor:(UIColor *)aColor cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)imageWithColor:(UIColor *)aColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

- (UIImage *)imageWithTintColor:(UIColor *)color;

- (UIImage *)imageWithTintColor:(UIColor *)color fraction:(CGFloat)fraction;

//设置图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
