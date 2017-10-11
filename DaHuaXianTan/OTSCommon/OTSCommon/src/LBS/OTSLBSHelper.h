//
//  OTSLBSHelper.h
//  OTSCore
//
//  Created by Jerry on 2017/8/17.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "OTSPromise.h"

@interface OTSLBSHelper : NSObject

@property(nonatomic, strong, readonly) CLLocationManager *locationManager;
@property(nonatomic, strong, readonly) CLLocation *lastLocation;

- (OTSPromise *)startUserLocationService;//CLLocation
- (void)stopUserLocationService;

- (OTSPromise *)geocodeAddress:(NSString *)addressName;//[CLPlacemark]
- (OTSPromise *)reverseGeocodeLocation:(CLLocation *)location;//[CLPlacemark]

@end


@interface CLLocation (MarsCoordinate)

@property(nonatomic, readonly) CLLocationCoordinate2D marsCoordinate;

@end
