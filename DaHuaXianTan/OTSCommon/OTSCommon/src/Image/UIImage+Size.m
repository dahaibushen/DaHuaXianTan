//
//  UIImage+Size.m
//  OTSCore
//
//  Created by liuwei7 on 2017/9/20.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)

//等比例缩放
- (UIImage *)scaleToSize:(CGSize)size {
    //不用CGImageGetHeight(self.CGImage)，图片拍摄后会旋转90度，exif属性会记录，CGImageGetHeight实际会获得宽度而不是高度
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    float verticalRadio = size.height * 1.0 / height;
    float horizontalRadio = size.width * 1.0 / width;
    
    float radio;
    if (verticalRadio > 1 && horizontalRadio > 1) {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    } else {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width * radio;
    height = height * radio;
    
    int xPos = (size.width - width) / 2;
    int yPos = (size.height - height) / 2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 *	按照尺寸缩放图片
 *
 *	@param aSize
 *
 */
- (UIImage *)shrinkImageForSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (NSData *)dataWithBytesLimit:(NSUInteger)bytes {
    NSData *ret = UIImagePNGRepresentation(self);
    if (ret.length > bytes) {
        float salce=0.75;
        float maxSize=125/salce;
        
        while (ret.length > bytes) {
            maxSize=maxSize*salce;
            ret = UIImagePNGRepresentation([self scaleToSize:CGSizeMake(maxSize, maxSize)]);
        }
    }
    return ret;
}

@end
