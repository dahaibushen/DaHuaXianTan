//
//  OTSCalendarNotification.h
//  OneStoreBase
//
//  Created by HUI on 16/6/30.
//  Copyright © 2016年 OneStoreBase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

//当无错误返回，会显示当前日历的访问权限
typedef void(^OTSCalendarNotifCompletionBlock)(BOOL success, NSError *anError);

@interface OTSCalendarNotificationCenter : NSObject

/*
 *创建一条日历提醒
 */
+ (void)creatCalendarNotificationWithStartDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                     alarmDate:(NSDate *)alarmDate
                                 remindContent:(NSString *)remindContent
                                     routerUrl:(NSString *)routerUrl
                                    eventStore:(EKEventStore *)eventStore
                               completionBlock:(OTSCalendarNotifCompletionBlock)aCompletionBlock;

/*
 *取消日历提醒
 */
+ (void)cancelCalendarNotificationWithStartDate:(NSDate *)startDate
                                     eventStore:(EKEventStore *)eventStore
                                  remindContent:(NSString *)remindContent
                                completionBlock:(OTSCalendarNotifCompletionBlock)aCompletionBlock;

@end
