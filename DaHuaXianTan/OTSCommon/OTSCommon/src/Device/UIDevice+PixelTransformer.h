//
//  UIDevice+PixelTransformer.h
//  OTSCore
//
//  Created by Jerry on 2017/9/11.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define OTS_RATIOED_PIXEL(ORIG_PIXEL) [UIDevice pixelWithValue:(ORIG_PIXEL) refrence:OTSDeviceRefrenceInch4_7]

typedef NS_ENUM(NSUInteger, OTSDeviceRefrence) {
    OTSDeviceRefrenceUnknown = 0,
    OTSDeviceRefrenceInch3_5,
    OTSDeviceRefrenceInch4_0,
    OTSDeviceRefrenceInch4_7,
    OTSDeviceRefrenceInch5_5,
    OTSDeviceRefrenceInch5_8,
    OTSDeviceRefrenceInch9_7,
    OTSDeviceRefrenceInch9_7Land,
    OTSDeviceRefrenceInch10_5,
    OTSDeviceRefrenceInch10_5land,
    OTSDeviceRefrenceInch12_9,
    OTSDeviceRefrenceInch12_9land,
    
};

@interface UIDevice (PixelTransformer)

@property(nonatomic, readonly, class) OTSDeviceRefrence currentDeviceRefrence;

+ (CGFloat)pixelWithValue:(CGFloat)origPixel
                 refrence:(OTSDeviceRefrence)deviceRefrence;

@end

NS_ASSUME_NONNULL_END
