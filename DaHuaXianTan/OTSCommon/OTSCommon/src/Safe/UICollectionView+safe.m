//
//  UICollectionView+safe.m
//  OneStoreBase
//
//  Created by huangjiming on 5/25/16.
//  Copyright © 2016 OneStoreBase. All rights reserved.
//

#import "UICollectionView+safe.h"
#import <objc/runtime.h>

@implementation UICollectionView (safe)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(selectItemAtIndexPath:animated:scrollPosition:)), class_getInstanceMethod(self, @selector(safeSelectItemAtIndexPath:animated:scrollPosition:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(scrollToItemAtIndexPath:atScrollPosition:animated:)), class_getInstanceMethod(self, @selector(safeScrollToItemAtIndexPath:atScrollPosition:animated:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(reloadSections:)), class_getInstanceMethod(self, @selector(safeReloadSections:)));
}

- (void)safeSelectItemAtIndexPath:(NSIndexPath *)indexPath
                         animated:(BOOL)animated
                   scrollPosition:(UICollectionViewScrollPosition)scrollPosition {
    if (indexPath.section >= [self numberOfSections] || indexPath.item >= [self numberOfItemsInSection:indexPath.section]) {
        NSAssert(false, @"selectItemAtIndexPath:animated:scrollPosition: 有问题，请修复");
        return;
    }

    [self safeSelectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}


- (void)safeScrollToItemAtIndexPath:(NSIndexPath *)indexPath
                   atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                           animated:(BOOL)animated {
    if (!indexPath || indexPath.section >= [self numberOfSections] || indexPath.item >= [self numberOfItemsInSection:indexPath.section]) {
        NSAssert(false, @"scrollToItemAtIndexPath:atScrollPosition:animated: 有问题，请修复");
        return;
    }

    [self safeScrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)safeReloadSections:(NSIndexSet *)sections {
    if ([sections indexGreaterThanOrEqualToIndex:[self numberOfSections]] != NSNotFound) {
        NSAssert(false, @"reloadSections: 有问题，请修复");
        return;
    }

    [self safeReloadSections:sections];
}

@end
