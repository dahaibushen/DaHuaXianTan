//
//  FreedomLabel.h
//  OneStorePad
//
//  Created by Roy on 15/4/16.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VerticalAlignment) {
    VerticalAlignmentTop = 0,
    VerticalAlignmentMiddle = 1,
    VerticalAlignmentBottom = 2
};

@interface FreedomLabel : UILabel

@property(nonatomic, assign) VerticalAlignment verticalAlignment;

@end
