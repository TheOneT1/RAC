//
//  ViewController4.m
//  RAC
//
//  Created by fs_work on 2017/4/6.
//  Copyright © 2017年 fs_work. All rights reserved.
//

#import "ViewController4.h"
#import "RACLocationManager.h"
@interface ViewController4 ()


@end

@implementation ViewController4


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    

    
    @weakify(self);
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
     
        [[[RACLocationManager  shareManager] rac_getLocationCLPlacemark] subscribeNext:^(id  _Nullable x) {
         CLPlacemark *placemark = (CLPlacemark*) x;
         @strongify(self);
         self.cityLabel.text =placemark.locality.length > 0 ? placemark.locality : placemark.administrativeArea;
         self.button.enabled = NO;
         
     } error:^(NSError * _Nullable error) {
         
         NSLog(@"定位失败 = %@",error);
         
     }];
 }];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
