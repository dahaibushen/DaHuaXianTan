//
//  ViewController.m
//  DaHuaXianTan
//
//  Created by huyiyong on 17/2/9.
//  Copyright © 2017年 huyiyong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *arr = @[].mutableCopy;
    for (int i=0; i<4; i++) {
        [arr addObject:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
