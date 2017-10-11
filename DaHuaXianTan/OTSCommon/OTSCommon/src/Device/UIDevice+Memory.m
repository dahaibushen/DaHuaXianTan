//
//  UIDevice+Memory.m
//  OTSKit
//
//  Created by Jerry on 2017/1/2.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "UIDevice+Memory.h"
#import <mach/mach.h>

@implementation UIDevice (Memory)

- (double)availableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
            HOST_VM_INFO,
            (host_info_t) &vmStats,
            &infoCount);

    if (kernReturn != KERN_SUCCESS) {
        return -1;
    }

    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

- (double)usedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
            TASK_BASIC_INFO,
            (task_info_t) &taskInfo,
            &infoCount);

    if (kernReturn != KERN_SUCCESS) {
        return -1;
    }

    return taskInfo.resident_size / 1024.0 / 1024.0;
}
@end
