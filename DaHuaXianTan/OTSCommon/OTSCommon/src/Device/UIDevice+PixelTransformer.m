//
//  UIDevice+PixelTransformer.m
//  OTSCore
//
//  Created by Jerry on 2017/9/11.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "UIDevice+PixelTransformer.h"

@implementation UIDevice (PixelTransformer)

static NSInteger __CURRENT_DEVICE_REFRENCE = -1;

+ (CGFloat)pixelWithValue:(CGFloat)origPixel
                 refrence:(OTSDeviceRefrence)deviceRefrence {
    CGFloat currentRatio = [[UIDevice multiplicative][@(UIDevice.currentDeviceRefrence)] floatValue];
    CGFloat refrenceRatio = [[UIDevice multiplicative][@(deviceRefrence)] floatValue];
    return ceil(origPixel * currentRatio / MAX(refrenceRatio, 1));
}

+ (OTSDeviceRefrence)currentDeviceRefrence {
    if (__CURRENT_DEVICE_REFRENCE < 0) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        if (CGSizeEqualToSize(size, CGSizeMake(320, 480))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch3_5;
        } else if (CGSizeEqualToSize(size, CGSizeMake(320, 568))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch4_0;
        } else if (CGSizeEqualToSize(size, CGSizeMake(375, 667))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch4_7;
        } else if (CGSizeEqualToSize(size, CGSizeMake(375, 812))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch5_8;
        } else if (CGSizeEqualToSize(size, CGSizeMake(414, 736))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch5_5;
        } else if (CGSizeEqualToSize(size, CGSizeMake(768, 1024))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch9_7;
        } else if (CGSizeEqualToSize(size, CGSizeMake(1024, 768))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch9_7Land;
        } else if (CGSizeEqualToSize(size, CGSizeMake(834, 1112))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch10_5;
        } else if (CGSizeEqualToSize(size, CGSizeMake(1112, 834))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch10_5land;
        } else if (CGSizeEqualToSize(size, CGSizeMake(1024, 1366))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch12_9;
        } else if (CGSizeEqualToSize(size, CGSizeMake(1366, 1024))) {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceInch12_9land;
        } else {
            __CURRENT_DEVICE_REFRENCE = OTSDeviceRefrenceUnknown;
        }
    }
    return __CURRENT_DEVICE_REFRENCE;
}

+ (NSDictionary<NSNumber *, NSNumber *> *)multiplicative {
    return @{@(OTSDeviceRefrenceUnknown): @1,
            @(OTSDeviceRefrenceInch3_5): @320,
            @(OTSDeviceRefrenceInch4_0): @320,
            @(OTSDeviceRefrenceInch4_7): @375,
            @(OTSDeviceRefrenceInch5_5): @414,
            @(OTSDeviceRefrenceInch5_8): @375,
            @(OTSDeviceRefrenceInch9_7): @768,
            @(OTSDeviceRefrenceInch9_7Land): @1024,
            @(OTSDeviceRefrenceInch10_5): @834,
             @(OTSDeviceRefrenceInch10_5land): @1112,
            @(OTSDeviceRefrenceInch12_9): @1024,
            @(OTSDeviceRefrenceInch12_9land): @1366};
}

@end
