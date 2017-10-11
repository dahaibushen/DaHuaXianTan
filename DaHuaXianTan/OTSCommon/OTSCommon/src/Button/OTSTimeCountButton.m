//
//  OTSTimeCountButton.m
//  OneStoreBase
//
//  Created by huangjiming on 1/11/16.
//  Copyright © 2016 OneStoreBase. All rights reserved.
//

#import "OTSTimeCountButton.h"
#import <OTSCore/OTSCore.h>

@interface OTSTimeCountButton ()
@property(nonatomic, strong) NSString *titleFormat;
@property(nonatomic, strong) NSString *normalTitle;
@property(nonatomic, weak) NSTimer *mTimer;
@property(nonatomic, strong) NSString *countingTitle;
@end

@implementation OTSTimeCountButton

- (id)initWithFrame:(CGRect)frame
               time:(float)time
        normalTitle:(NSString *)normalTitle
      countingTitle:(NSString *)countingTitle {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleFormat = [countingTitle safeStringByAppendingString:@"(%.fs)"];
        self.mTimeInterVal = time;
        self.mOriginalTime = time;
        self.normalTitle = normalTitle;
        self.countingTitle = countingTitle;
        [self setTitle:normalTitle forState:UIControlStateNormal];
        [self.titleLabel setNumberOfLines:0];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

/**
 *  功能：初始化方法，传入倒计时时间和文字内容
 */
- (void)timeMethod {
    self.mTimeInterVal--;
    if (_mTimeInterVal < 0) {
        [self.mTimer invalidate];
        [self setMTimer:nil];
        [self setTitle:_normalTitle forState:UIControlStateNormal];
        if (_myReplaceTitleBlock) {
            [self setTitle:_countingTitle forState:UIControlStateNormal];
        }
        self.enabled = YES;
    } else {
        [self setTitle:[NSString stringWithFormat:_titleFormat, _mTimeInterVal] forState:UIControlStateDisabled];
    }
}

/**
 *  功能：开始倒计时
 */
- (void)startCounting {
    self.mTimeInterVal = _mOriginalTime;
    self.mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
    self.enabled = NO;
}

/**
 *  功能：父视图发生改变时调用，这里用以使timer失效
 */
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.mTimer) {
        [self.mTimer invalidate];
        [self setMTimer:nil];
    }
}

- (void)replaceNormalTitleWithCountingTitle:(void (^)(void))block {
    _myReplaceTitleBlock = [block copy];
}
@end
