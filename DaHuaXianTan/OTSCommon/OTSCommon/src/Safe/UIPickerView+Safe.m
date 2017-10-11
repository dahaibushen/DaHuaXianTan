//
//  UIPickerView+Safe.m
//  OTSCore
//
//  Created by liuwei7 on 2017/9/18.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "UIPickerView+Safe.h"

@implementation UIPickerView (Safe)

- (void)safe_selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    if (row >= 0 && row <= [self numberOfRowsInComponent:component] - 1) {
        [self selectRow:row inComponent:component animated:animated];
    }
}

@end
