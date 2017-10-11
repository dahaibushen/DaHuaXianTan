//
//  ViewController.m
//  DaHuaXianTan
//
//  Created by huyiyong on 17/2/9.
//  Copyright © 2017年 huyiyong. All rights reserved.
//

#import "ViewController.h"
#import <OTSCommon/OTSCommon.h>



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    OTSEnlargeButton *button = [OTSEnlargeButton new];
    [self.view addSubview:button];
    button.frame = CGRectMake(120, 120, 120, 120);
    button.backgroundColor = [UIColor colorWithRGB:0x343233];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
