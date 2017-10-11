//
//  OTSCalendarNotification.m
//  OneStoreBase
//
//  Created by HUI on 16/6/30.
//  Copyright © 2016年 OneStoreBase. All rights reserved.
//

#import "OTSCalendarNotificationCenter.h"

@implementation OTSCalendarNotificationCenter

+ (void)creatCalendarNotificationWithStartDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                     alarmDate:(NSDate *)alarmDate
                                 remindContent:(NSString *)remindContent
                                     routerUrl:(NSString *)routerUrl
                                    eventStore:(EKEventStore *)eventStore
                               completionBlock:(OTSCalendarNotifCompletionBlock)aCompletionBlock {
    EKAuthorizationStatus curEKStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (curEKStatus == EKAuthorizationStatusNotDetermined) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error || !granted) {
                    if (aCompletionBlock) {
                        aCompletionBlock(granted, error);
                    }
                } else {
                    [OTSCalendarNotificationCenter creatCalendarNotificationIsAuthWithStartDate:startDate endDate:endDate alarmDate:alarmDate remindContent:remindContent routerUrl:routerUrl eventStore:eventStore completionBlock:aCompletionBlock];
                }
            });
        }];
    } else if (curEKStatus == EKAuthorizationStatusAuthorized) {
        [OTSCalendarNotificationCenter creatCalendarNotificationIsAuthWithStartDate:startDate endDate:endDate alarmDate:alarmDate remindContent:remindContent routerUrl:routerUrl eventStore:eventStore completionBlock:aCompletionBlock];
    } else {
        if (aCompletionBlock) {
            aCompletionBlock(NO, nil);
        }
    }
}

+ (void)creatCalendarNotificationIsAuthWithStartDate:(NSDate *)startDate
                                             endDate:(NSDate *)endDate
                                           alarmDate:(NSDate *)alarmDate
                                       remindContent:(NSString *)remindContent
                                           routerUrl:(NSString *)routerUrl
                                          eventStore:(EKEventStore *)eventStore
                                     completionBlock:(OTSCalendarNotifCompletionBlock)aCompletionBlock {
    if (startDate) {
        if ([eventStore defaultCalendarForNewEvents] == nil) {
            eventStore = [[EKEventStore alloc] init];
        }
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.timeZone = [NSTimeZone systemTimeZone];
        event.title = remindContent;
        event.startDate = startDate;
        event.endDate = endDate;
        if (alarmDate != nil) {
            EKAlarm *oneAlarm = [EKAlarm alarmWithAbsoluteDate:alarmDate];
            [event addAlarm:oneAlarm];
        } else {
            [event addAlarm:[EKAlarm alarmWithRelativeOffset:0]];
        }
        if (routerUrl.length) {
            event.URL = [NSURL URLWithString:routerUrl];
        }
        event.calendar = [eventStore defaultCalendarForNewEvents];
        NSError *error;
        BOOL succees = [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
        if (aCompletionBlock) {
            aCompletionBlock(succees, error);
        }
    }
}

+ (void)cancelCalendarNotificationWithStartDate:(NSDate *)startDate
                                     eventStore:(EKEventStore *)eventStore
                                  remindContent:(NSString *)remindContent
                                completionBlock:(OTSCalendarNotifCompletionBlock)aCompletionBlock {
    NSArray *eventsArray = [self allCalendarEventsArrayWithEventStore:eventStore];
    BOOL isContainEvent = NO;
    BOOL deleteSuccess = NO;
    NSError *deleteError;
    if (eventsArray.count) {
        for (EKEvent *item in eventsArray) {
            if ([item.title isEqualToString:remindContent] && [item.startDate compare:startDate] == NSOrderedSame) {
                isContainEvent = YES;
                deleteSuccess = [eventStore removeEvent:item span:EKSpanThisEvent commit:YES error:&deleteError];
                break;
            }
        }
        if (!isContainEvent) {
            if (aCompletionBlock) {
                aCompletionBlock(NO, nil);
            }
        } else {
            if (aCompletionBlock) {
                aCompletionBlock(deleteSuccess, deleteError);
            }
        }
    } else {
        if (aCompletionBlock) {
            aCompletionBlock(NO, nil);
        }
    }
}

+ (NSArray *)allCalendarEventsArrayWithEventStore:(EKEventStore *)eventStore {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSDate *startDate = [formatter dateFromString:@"20160621000000"];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 2];
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    return [eventStore eventsMatchingPredicate:predicate];
}

@end
