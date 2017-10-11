//
//  UIView+Border.h
//  OTSCore
//
//  Created by Jerry on 2017/8/16.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, OTSBorderOption) {
    OTSBorderOptionNone           = 0,
    OTSBorderOptionTop            = 1 << 0,
    OTSBorderOptionLeft           = 1 << 1,
    OTSBorderOptionBottom         = 1 << 2,
    OTSBorderOptionRight          = 1 << 3,
    OTSBorderOptionAll            = OTSBorderOptionTop | OTSBorderOptionLeft | OTSBorderOptionBottom | OTSBorderOptionRight
};

@interface UIView (Border)

@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;//default is 1.0
@property (nonatomic, assign) UIEdgeInsets borderInsets UI_APPEARANCE_SELECTOR;//default is UIEdgeInsetsZero
@property (nonatomic, assign) OTSBorderOption borderOption UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong, null_resettable) UIColor *borderColor UI_APPEARANCE_SELECTOR;//default is #e6e6e6

@end

NS_ASSUME_NONNULL_END
