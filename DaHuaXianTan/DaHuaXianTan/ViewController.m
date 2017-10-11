//
//  ViewController.m
//  DaHuaXianTan
//
//  Created by huyiyong on 17/2/9.
//  Copyright © 2017年 huyiyong. All rights reserved.
//

#import "ViewController.h"
#import <OTSCommon/OTSCommon.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *homeTableView;
@property(nonatomic,strong)NSMutableArray *listArr;
@end

@implementation ViewController
-(UITableView*)homeTableView{
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        [_homeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
    }
    return _homeTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listArr = @[].mutableCopy;
    [self.view addSubview:self.homeTableView];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addData) userInfo:nil repeats:NO];
//    [self.homeTableView addLoadMoreFooterWithBlock:^(id  _Nonnull refreshView) {
//
//    } contentClass:[self class]];
    [self.homeTableView ];
}
#pragma mark 加载数据
-(void)addData{
    for (int i=0; i<7; i++) {
        [self.listArr addObject:@""];
    }
    [self.homeTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
@end
