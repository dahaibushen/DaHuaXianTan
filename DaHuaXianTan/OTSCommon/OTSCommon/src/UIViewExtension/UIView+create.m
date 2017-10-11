//
//  UIVIew+create.m
//  OneStoreFramework
//
//  Created by Aimy on 14-7-14.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "UIView+create.h"

@implementation UIView (create)

+ (instancetype)createWithNib
{
    return [self createWithNibName:NSStringFromClass(self) bundleName:nil];
}

+ (instancetype)createWithNibName:(NSString *)aXibName bundleName:(NSString *)aBundleName
{
    UINib *nib = [UINib nibWithNibName:aXibName bundle:[NSBundle mainBundle]];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    __block UIView *returnView = nil;
    [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id view = obj;
        if ([view isKindOfClass:self]) {
            *stop = YES;
            returnView = view;
            return ;
        }
    }];
    
    return returnView;
}

+ (instancetype)autolayoutView
{
    UIView *view = [[self alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
