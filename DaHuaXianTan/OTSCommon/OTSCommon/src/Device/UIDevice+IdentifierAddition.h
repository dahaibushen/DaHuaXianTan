//
//  UIDevice(Identifier).h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const OTS_EYCHAIN_DEVICECODE_KEY;

@interface UIDevice (IdentifierAddition)

/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */
@property(nonatomic, readonly) NSString *uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */
@property(nonatomic, readonly, nullable) NSString *uniqueGlobalDeviceIdentifier;

@property(nonatomic, readonly, nullable) NSString *macaddress;

@property(nonatomic, class, readonly) BOOL isJailBreak;

@property(nonatomic, readonly) NSString *ipAddress;


@end

NS_ASSUME_NONNULL_END
