//
//  UIScrollView+DeliverEvent.m
//  OneStoreFramework
//
//  Created by airspuer on 15/6/11.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import "UIScrollView+DeliverTouch.h"
#import <objc/runtime.h>

static char deliverTouchKey;

@implementation UIScrollView (DeliverTouch)

+ (void)load {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(touchesBegan:withEvent:)), class_getInstanceMethod(self, @selector(deliverTouchesBegan:withEvent:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(touchesMoved:withEvent:)), class_getInstanceMethod(self, @selector(deliverTouchesMoved:withEvent:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(touchesEnded:withEvent:)), class_getInstanceMethod(self, @selector(deliverTouchesEnded:withEvent:)));
    });
}

- (void)setDeliverTouchEvent:(BOOL)deliverEvent {
    objc_setAssociatedObject(self, &deliverTouchKey, @(deliverEvent), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)deliverTouchEvent {
    NSNumber *deleverEventNumber = objc_getAssociatedObject(self, &deliverTouchKey);
    return deleverEventNumber.boolValue;
}


- (void)deliverTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.deliverTouchEvent) {
        [self deliverTouchesBegan:touches withEvent:event];
        [self.nextResponder touchesBegan:touches withEvent:event];
    } else {
        [self deliverTouchesBegan:touches withEvent:event];
    }
}

- (void)deliverTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.deliverTouchEvent) {
        [self deliverTouchesMoved:touches withEvent:event];
        [self.nextResponder touchesMoved:touches withEvent:event];
    } else {
        [self deliverTouchesMoved:touches withEvent:event];
    }
}

- (void)deliverTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.deliverTouchEvent) {
        [self deliverTouchesEnded:touches withEvent:event];
        [self.nextResponder touchesEnded:touches withEvent:event];
    } else {
        [self deliverTouchesEnded:touches withEvent:event];
    }
}


@end