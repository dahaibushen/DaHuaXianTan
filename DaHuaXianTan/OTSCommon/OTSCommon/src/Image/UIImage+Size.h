//
//  UIImage+Size.h
//  OTSCore
//
//  Created by liuwei7 on 2017/9/20.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)

/**
 *  等比例缩放
 *
 *  @param size 大小
 *
 *  @return image
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 *	按照尺寸缩放图片
 *
 *	@param aSize CGSize
 *
 */
- (UIImage *)shrinkImageForSize:(CGSize)aSize;

- (NSData *)dataWithBytesLimit:(NSUInteger)bytes;

@end
