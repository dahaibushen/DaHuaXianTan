//
//  UIImage+Color.m
//  OTSCore
//
//  Created by Jerry on 2017/8/21.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)aColor {
    return [self imageWithColor:aColor size:CGSizeMake(1.0f, 1.0f) cornerRadius:0];
}

+ (UIImage *)imageWithColor:(UIColor *)aColor cornerRadius:(CGFloat)cornerRadius {
    CGFloat minSize = cornerRadius * 2 + 1;
    return [self imageWithColor:aColor size:CGSizeMake(minSize, minSize) cornerRadius:cornerRadius];
}

+ (UIImage *)imageWithColor:(UIColor *)aColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    if (cornerRadius) {
        CGFloat minSize = cornerRadius * 2 + 1;
        if (size.width < minSize) {
            size.width = minSize;
        }
        
        if (size.height < minSize) {
            size.height = minSize;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    if (cornerRadius) {
        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        roundedRect.lineWidth = 0;
        [roundedRect fill];
    } else {
        CGContextFillRect(context, rect);
    }
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (cornerRadius) {
        theImage = [theImage resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
    }
    return theImage;
}

- (UIImage *)imageWithTintColor:(UIColor *)color {
    // This method is designed for use with template images, i.e. solid-coloured mask-like images.
    return [self imageWithTintColor:color fraction:0.0]; // default to a fully tinted mask of the image.
}

- (UIImage *)imageWithTintColor:(UIColor *)color fraction:(CGFloat)fraction {
    if (color) {
        // Construct new image the same size as this one.
        UIImage *image;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
        if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
            UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f); // 0.f for scale means "scale for device's main screen".
        } else {
            UIGraphicsBeginImageContext([self size]);
        }
#else
        UIGraphicsBeginImageContext([self size]);
#endif
        CGRect rect = CGRectZero;
        rect.size = [self size];

        // Composite tint color at its own opacity.
        [color set];
        UIRectFill(rect);

        // Mask tint color-swatch to this image's opaque mask.
        // We want behaviour like NSCompositeDestinationIn on Mac OS X.
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];

        // Finally, composite this image over the tinted mask at desired opacity.
        if (fraction > 0.0) {
            // We want behaviour like NSCompositeSourceOver on Mac OS X.
            [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return image;
    }

    return self;
}

//设置图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha {

    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);

    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);

    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
