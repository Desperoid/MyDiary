//
//  MDWriteDiaryView.m
//  MyDiary
//
//  Created by Geng on 2017/4/5.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDWriteDiaryView.h"
#import "MDDiaryThemeManager.h"
#import <CoreLocation/CoreLocation.h>
#import "MDDateHelper.h"

@interface MDWriteDiaryView () <YYTextViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@end

@implementation MDWriteDiaryView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = 500;
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    self.geoCoder = [[CLGeocoder alloc] init];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY年MM月dd日";
    self.timeLabel.text = [formatter stringFromDate:now];
    
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    if (location) {
        [self.locationManager stopUpdatingHeading];
        NSString *latitude = [NSString stringWithFormat:@"N:%7.3f",location.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"E:%7.3f",location.coordinate.longitude];
        self.latitudeLabel.text = latitude;
        self.longitudeLabel.text = longitude;
    }
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        if (placemark) {
            NSString *location = [NSString stringWithFormat:@"%@%@%@%@%@%@",placemark.country, placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare];
            if (location) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.locationLabel.text = location;
                });
            }
        }
        
    }];
}


@end
