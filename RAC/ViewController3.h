//
//  ViewController3.h
//  RAC
//
//  Created by fs_work on 2017/3/31.
//  Copyright © 2017年 fs_work. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController3 : UIViewController

    @property (weak, nonatomic) IBOutlet UITextField *redTextField;
    @property (weak, nonatomic) IBOutlet UITextField *grennTextField;
    @property (weak, nonatomic) IBOutlet UITextField *blueTextField;

    @property (weak, nonatomic) IBOutlet UISlider *redSlider;
    @property (weak, nonatomic) IBOutlet UISlider *greenSlider;
    @property (weak, nonatomic) IBOutlet UISlider *blueSlider;
    @property (weak, nonatomic) IBOutlet UIView *dynamicColorView;
- (IBAction)dismiss:(id)sender;
@end
