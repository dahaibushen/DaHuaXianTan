//
//  OTSTimeCountButton.h
//  OneStoreBase
//
//  Created by huangjiming on 1/11/16.
//  Copyright © 2016 OneStoreBase. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^replaceTitleBlock)(void);

@interface OTSTimeCountButton : UIButton

/**
 *  功能：初始化方法，传入倒计时时间和文字内容
 */
- (id)initWithFrame:(CGRect)frame
               time:(float)time
        normalTitle:(NSString *)normalTitle
      countingTitle:(NSString *)countingTitle;

/**
 *  功能：开始倒计时
 */
- (void)startCounting;

/**
 *  功能：倒计时时间
 */
@property(nonatomic) float mTimeInterVal;

/**
 *  功能：原时间
 */
@property(nonatomic) float mOriginalTime;
@property(nonatomic, copy) replaceTitleBlock myReplaceTitleBlock;

/*
 * 功能： 第一次点击之后 改变按钮的title为CountingTitle（重新发送）
 */
- (void)replaceNormalTitleWithCountingTitle:(void (^)(void))block;
@end
