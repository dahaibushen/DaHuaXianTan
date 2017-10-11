//
//  OTSLBSHelper.m
//  OTSCore
//
//  Created by Jerry on 2017/8/17.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "OTSLBSHelper.h"

#define OTS_RESTRICTED_LOCATION_ERROR [NSError errorWithDomain:@"com.ots.core" code:0 userInfo:@{NSLocalizedDescriptionKey: @"无法使用定位服务,请在设置-隐私-定位服务中开启"}]
#define OTS_GEOCODE_NO_RESULT [NSError errorWithDomain:@"com.ots.core" code:0 userInfo:@{NSLocalizedDescriptionKey: @"地址解析失败"}]

@interface OTSLBSHelper () <CLLocationManagerDelegate>

@property(nonatomic, strong) OTSPromise *locationPromise;
@property(nonatomic, strong) CLGeocoder *geocoder;
@property(nonatomic, strong) CLLocation *lastLocation;

@end

@implementation OTSLBSHelper

@synthesize locationManager = _locationManager;

- (OTSPromise *)startUserLocationService {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return [OTSPromise reject:OTS_RESTRICTED_LOCATION_ERROR];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationPromise = [OTSPromise new];
    [self.locationManager startUpdatingLocation];
    return self.locationPromise;
}

- (void)stopUserLocationService {
    [self.locationManager stopUpdatingLocation];
}

- (OTSPromise *)geocodeAddress:(NSString *)addressName {
    OTSPromise *promosie = [[OTSPromise alloc] init];
    [self.geocoder geocodeAddressString:addressName completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        if (error || !placemarks.count) {
            [promosie reject:error ?: OTS_GEOCODE_NO_RESULT];
        } else {
            [promosie resolve:placemarks];
        }
    }];
    return promosie;
}

- (OTSPromise *)reverseGeocodeLocation:(CLLocation *)location {
    OTSPromise *promosie = [[OTSPromise alloc] init];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        if (error || !placemarks.count) {
            [promosie reject:error ?: OTS_GEOCODE_NO_RESULT];
        } else {
            [promosie resolve:placemarks];
        }
    }];
    return promosie;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (!self.locationPromise || self.locationPromise.status != OTSPromiseStatusPending) {
        return;
    }

    if ((status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [manager startUpdatingLocation];
    } else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        [self.locationPromise reject:OTS_RESTRICTED_LOCATION_ERROR];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.lastLocation = locations.lastObject;
    [self stopUserLocationService];
    [self.locationPromise resolve:self.lastLocation];
}

#pragma mark - Getter & Setter

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
//        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
//            _locationManager.allowsBackgroundLocationUpdates = YES;
//        }
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 500;
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil] forKey:@"AppleLanguages"];
    }
    return _geocoder;
}

@end


const double a = 6378245.0;
const double ee = 0.00669342162296594323;

@implementation CLLocation (MarsCoordinate)

- (CLLocationCoordinate2D)marsCoordinate {
    if ([CLLocation outOfChina:self]) {
        return self.coordinate;
    }
    double dLat = [CLLocation transformLatWithX:self.coordinate.longitude - 105.0 y:self.coordinate.latitude - 35.0];
    double dLon = [CLLocation transformLonWithX:self.coordinate.longitude - 105.0 y:self.coordinate.latitude - 35.0];
    double radLat = self.coordinate.latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    return CLLocationCoordinate2DMake(self.coordinate.latitude + dLat, self.coordinate.longitude + dLon);
}

+ (BOOL)outOfChina:(CLLocation *)location {
    if (location.coordinate.longitude < 72.004 || location.coordinate.longitude > 137.8347) {
        return YES;
    }
    if (location.coordinate.latitude < 0.8293 || location.coordinate.latitude > 55.8271) {
        return YES;
    }
    return NO;
}

+ (double)transformLatWithX:(double)x y:(double)y {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double)transformLonWithX:(double)x y:(double)y {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

@end
