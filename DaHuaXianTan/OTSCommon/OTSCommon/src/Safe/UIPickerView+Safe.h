//
//  UIPickerView+Safe.h
//  OTSCore
//
//  Created by liuwei7 on 2017/9/18.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPickerView (Safe)

- (void)safe_selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

@end
