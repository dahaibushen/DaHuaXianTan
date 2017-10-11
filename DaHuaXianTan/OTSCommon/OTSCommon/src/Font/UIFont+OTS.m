//
//  UIFont+OTS.m
//  OTSBase
//
//  Created by liuwei7 on 2017/9/8.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "UIFont+OTS.h"

@implementation UIFont (OTS)

+ (UIFont *)systemFontOfSizeForiPhone:(CGFloat)iSize iPad:(CGFloat)jSize
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [UIFont systemFontOfSize:jSize] : [UIFont systemFontOfSize:iSize];
}

@end
