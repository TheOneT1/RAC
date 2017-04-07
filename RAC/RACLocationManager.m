//
//  RACLocationManager.m
//  RAC
//
//  Created by fs_work on 2017/4/6.
//  Copyright © 2017年 fs_work. All rights reserved.
//


#import "RACLocationManager.h"


@implementation RACLocationManager

+(instancetype)shareManager
{
    static RACLocationManager *racClm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        racClm = [[self alloc] init];
    });
    return racClm;
}
-(CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter = 1.0;
        _manager.delegate = self;
    }
    
    return _manager;
}

-(CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

-(RACSignal *)authorizedSignal
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestWhenInUseAuthorization];
        
        return [[self rac_signalForSelector:@selector(locationManager:didChangeAuthorizationStatus:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(id  _Nullable value) {
            
            return @([value[1] integerValue] == kCLAuthorizationStatusAuthorizedWhenInUse);
        }];
    }
    return [RACSignal return:@([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)];
}


-(RACSignal *)rac_getLocationCLPlacemark
{
    @weakify(self);
    
    return [[[[self authorizedSignal] filter:^BOOL(id  _Nullable value) {
        
        return [value boolValue];
        
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        
        @strongify(self);
        // 跟踪位置更新代理
        return  [[[[[[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(id  _Nullable value) {
            
            // 位置更新成功
            NSLog(@"位置更新成功 = %@",value);
            return value[1];
            
        }] merge:[[self rac_signalForSelector:@selector(locationManager:didFailWithError:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(id  _Nullable value) {
            // 位置更新失败
            NSLog(@"位置更新失败 = %@",value);
            return [RACSignal error:value[1]];
            
        }]] take:1] initially:^{
            @strongify(self);
            [self.manager startUpdatingLocation];
            
        }] finally:^{
            @strongify(self);
            [self.manager stopUpdatingLocation];
        }];
        
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        
        CLLocation *localtion = [value firstObject];
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            [self.geocoder reverseGeocodeLocation:localtion completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
                if (error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                    
                }else{
                    [subscriber sendNext:[placemarks firstObject]];
                    [subscriber sendCompleted];
                }
                
            }];
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];

}

@end
