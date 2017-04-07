//
//  RACLocationManager.h
//  RAC
//
//  Created by fs_work on 2017/4/6.
//  Copyright © 2017年 fs_work. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RACLocationManager : NSObject<CLLocationManagerDelegate>

+(instancetype)shareManager;

@property(nonatomic,strong) CLLocationManager *manager;

@property(nonatomic) CLGeocoder *geocoder;

-(RACSignal *)rac_getLocationCLPlacemark;
@end
