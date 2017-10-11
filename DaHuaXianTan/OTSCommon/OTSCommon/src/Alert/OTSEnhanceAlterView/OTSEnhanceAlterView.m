//
//  OTSEnhanceAlterView.m
//  OneStoreFramework
//
//  Created by ChaiJun on 15/8/31.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import "OTSEnhanceAlterView.h"
#import <OTSCore/UIColor+Convenience.h>

#define ALLineColorOfGray hex(0xa7afbb)
#define ALLineColorOfBlue hex(0x83b3f6)
#define ALTextColorOfButton hex(0x007aff)
#define ALTextColorOfTitle hex(0x000000)
#define ALTextColorOfMessage hex(0x000000)
#define ALFontOfTitle [UIFont boldSystemFontOfSize:15]
#define ALFontOfMessage [UIFont systemFontOfSize:13]
#define ALFontOfNormalButton [UIFont systemFontOfSize:15]
#define ALFontOfCancelButton [UIFont boldSystemFontOfSize:15]

#define ALBtnBGColorOfHL hex(0xc5ccd4)

@interface OTSEnhanceAlterView()

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSAttributedString *title;
@property (nonatomic, strong) NSAttributedString *message;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation OTSEnhanceAlterView

- (instancetype)initWithTitle:(NSAttributedString *)title
                      message:(NSAttributedString *)message
                     delegate:(id /*<BMAlertViewDelegate>*/)delegate
                       titles:(NSArray *)titles{
    if (self = [super init]) {
         self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.buttons = titles;
        
        [self initSetup];
    }
    return self;
}

- (void)initSetup{
    [self setupUI];
}

- (void)setupUI{
    self.width = 270;
    
    CGFloat verticalSpace = 20;
    CGFloat horizentalSpace = 20;
    CGFloat btnHeight = 44;
    
    CGFloat height = 0;
    
    //self
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.98f];
    _bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:_bgView];
    
    if (_title.length > 0) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = ALTextColorOfTitle;
        titleLabel.font = ALFontOfTitle;
        titleLabel.attributedText = _title; //注意，要放在label设置font，textColor等属性之后。
        titleLabel.backgroundColor = [UIColor clearColor];
        CGSize titleSize = [_title.string boundingRectWithSize:CGSizeMake(self.width - 2 * horizentalSpace, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLabel.font} context:nil].size;
        titleLabel.size = titleSize;
        titleLabel.centerX = self.width/2;
        titleLabel.top = verticalSpace;
        [self addSubview:titleLabel];
        
        height = titleLabel.bottom;
    }
    
    if (_message.length > 0) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = ALTextColorOfMessage;
        messageLabel.font = ALFontOfMessage;
        messageLabel.attributedText = _message;//注意，要放在label设置font，textColor等属性之后。
        messageLabel.backgroundColor = [UIColor clearColor];
        CGSize messageSize = [_message.string boundingRectWithSize:CGSizeMake(self.width - 2*horizentalSpace, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:messageLabel.font} context:nil].size;
        messageLabel.size = messageSize;
        messageLabel.centerX = self.width/2;
        if (fabs(height) < 0.0001) {
            messageLabel.top = verticalSpace;
        }else{
            messageLabel.top = height + 10;
        }
        [self addSubview:messageLabel];
        
        height = messageLabel.bottom;
    }
    
    //分割线
    if (!(fabs(height) < 0.0001)) {
        UIView *seperator = [[UIView alloc] init];
        seperator.width = self.width;
        seperator.height = 0.5f;
        if ([_buttons count] >= 3) {
            seperator.backgroundColor = ALLineColorOfBlue;
        }else{
            seperator.backgroundColor = ALLineColorOfGray;
        }
        
        seperator.top = height + verticalSpace;
        [self addSubview:seperator];
        
        height = seperator.bottom;
    }
    
    //暂时支持2个按钮
    
    if ([_buttons count] == 1) {
        CGRect tmpFrame = CGRectMake(0, height, self.width, btnHeight);
        UIButton *btn = [self getBtnWithText:[_buttons firstObject]
                                       frame:tmpFrame];
        [btn addTarget:self
                action:@selector(actionClick:)
      forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = ALFontOfCancelButton;
        [self addSubview:btn];
        height = btn.bottom;
    }else{
        //目前只支持2个按钮
        for (int i = 0; i < 2; i ++) {
            CGRect tmpFrame = CGRectMake(i * (self.width/2), height, self.width/2, btnHeight);
            UIButton *btn = [self getBtnWithText:[_buttons objectAtIndex:i]
                                           frame:tmpFrame];
            if (i == 0) {
                btn.titleLabel.font = ALFontOfCancelButton;
            }
            btn.tag = i;
            [btn addTarget:self
                    action:@selector(actionClick:)
          forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        //垂直 分割线
        UIView *verticalLine = [[UIView alloc] init];
        verticalLine.backgroundColor = ALLineColorOfGray;
        verticalLine.height = btnHeight;
        verticalLine.width = 0.5f;
        verticalLine.centerX = self.width/2;
        verticalLine.top = height;
        [self addSubview:verticalLine];
        
        height += btnHeight;
    }
    
    self.height = height;
}

- (UIButton *)getBtnWithText:(NSString *)text frame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:ALTextColorOfButton forState:UIControlStateNormal];
    [btn setBackgroundImage:nil
                   forState:UIControlStateNormal];
    UIImage *hlImage = [self getImageWithColor:ALBtnBGColorOfHL
                                          size:frame.size];
    [btn setBackgroundImage:hlImage
                   forState:UIControlStateHighlighted];
    btn.titleLabel.font = ALFontOfNormalButton;
    btn.frame = frame;
    
    return btn;
}

- (UIImage *)getImageWithColor:(UIColor *)bgColor size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextSetLineWidth(context, 0);
    [bgColor setFill];
    CGContextDrawPath(context, kCGPathFill);
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

#pragma mark - action

- (void)actionClick:(id)sender{
    if ([_delegate respondsToSelector:@selector(bmAlertView:clickedButtonAtIndex:)]) {
        UIButton *btn = (UIButton *)sender;
        [_delegate bmAlertView:self clickedButtonAtIndex:btn.tag];
    }
}

@end
