//
//  UITabBar+CustomTransition.m
//  OTSCore
//
//  Created by Jerry on 2017/8/22.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "UITabBar+CustomTransition.h"
#import "NSObject+Runtime.h"

static NSString *const showActionKey = @"OTS_TABBAR_SHOW_ACTION_KEY";
static NSString *const hideActionKey = @"OTS_TABBAR_HIDE_ACTION_KEY";

@implementation UITabBar (CustomTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeMethod:@selector(actionForLayer:forKey:) withMethod:@selector(OTS_UITabbar_CustomTransition_actionForLayer:forKey:)];
    });
}

- (id <CAAction>)OTS_UITabbar_CustomTransition_actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    if ([event isEqualToString:@"position"] && self.superview) {//ignored if it has not been shown.
        if (layer.position.x < 0) {//intend to show tabbar
            return self.customShowAction;
        } else if (layer.position.x > 0) {
            return self.customHideAction;
        }
    }
    return [self OTS_UITabbar_CustomTransition_actionForLayer:layer forKey:event];
}

#pragma mark - Getter & Setter

- (id <CAAction>)customShowAction {
    id <CAAction> ret = [self getAssociatedObjectForKey:showActionKey];
    if (!ret) {
        CATransition *defaultPushAction = [[CATransition alloc] init];
        defaultPushAction.duration = [CATransaction animationDuration];
        defaultPushAction.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        defaultPushAction.type = kCATransitionPush;
        defaultPushAction.subtype = kCATransitionFromTop;
        ret = defaultPushAction;
    }
    return ret;
}

- (void)setCustomShowAction:(id <CAAction>)customShowAction {
    [self setAssociatedObject:customShowAction forKey:showActionKey policy:OTSAssociationPolicyRetainNonatomic];
}

- (id <CAAction>)customHideAction {
    id <CAAction> ret = [self getAssociatedObjectForKey:hideActionKey];
    if (!ret) {
        CATransition *defaultPushAction = [[CATransition alloc] init];
        defaultPushAction.duration = [CATransaction animationDuration];
        defaultPushAction.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        defaultPushAction.type = kCATransitionPush;
        defaultPushAction.subtype = kCATransitionFromBottom;
        ret = defaultPushAction;
    }
    return ret;
}

- (void)setCustomHideAction:(id <CAAction>)customShowAction {
    [self setAssociatedObject:customShowAction forKey:hideActionKey policy:OTSAssociationPolicyRetainNonatomic];
}

@end
