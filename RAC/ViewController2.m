//
//  ViewController2.m
//  RAC
//
//  Created by fs_work on 2017/3/31.
//  Copyright © 2017年 fs_work. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
    @property (weak, nonatomic) IBOutlet UITextField *accountTextField;
    @property (weak, nonatomic) IBOutlet UITextField *psdTextfield;
    @property (weak, nonatomic) IBOutlet UIButton *loginButton;
    @property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    RACSignal *enableSignal = [self.accountTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        
//        
//        return @(value.length > 0);
//    }];
    
    // 合并信号
    RACSignal *enableSignal= [[RACSignal combineLatest:@[self.accountTextField.rac_textSignal,self.psdTextfield.rac_textSignal] ] map:^id _Nullable(id  _Nullable value) {
        
//        NSLog(@"value = %@",value);
        
        return @([value[0] length] > 0 && [value[1] length] > 5);
    }];
    
    self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"点击了登录按钮");
            
//            // 处理异步操作时 使用  如点击一个按钮之后让他3秒之后才可再次点击
//            [subscriber sendNext:@"124567"];
//            [subscriber sendCompleted];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [subscriber sendNext:[[NSDate date] description]];
//                [subscriber sendNext:@"124567"]; //可以获取发送的内容
                
                [subscriber sendCompleted];
            });
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
        
    }];
    
    [RACObserve(self.loginButton, enabled) subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"监听self.loginButton, enabled = %@",x);
        
        if ([x integerValue] ==1) {
            
            [self.loginButton setTitle:@"点我吧" forState:normal];
            
            [self.loginButton setBackgroundColor:[UIColor yellowColor]];
            
        }else{
            
            [self.loginButton setTitle:@"登录" forState:normal];
            
            [self.loginButton setBackgroundColor:[UIColor lightGrayColor]];
        }
        
    }];
    
    [[[self.loginButton rac_command] executionSignals] subscribeNext:^(RACSignal<id> * _Nullable x) {
        
        NSLog(@"获取[subscriber sendNext:@124567]; 的信号x = %@",x); // 此时获取就是一个   [subscriber sendNext:@"124567"]; 的信号
        
        [x subscribeNext:^(id  _Nullable x) {
            
            NSLog(@"获取[subscriber sendNext:@124567]; 的值x = %@ ",x); //此时获取就是取值 124567
        }];
    }];

    
    
//    
//    // label 点击手势事件
//    
//    UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc] init];
//    [self.accountLabel setUserInteractionEnabled:YES];
//    [ self.accountLabel addGestureRecognizer:tapg];
//    [[tapg rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
//        
//        NSLog(@"点击账户label");
//        
//      
//    }];
//    
//    
//    // textfield 绑定事件
//    
//    [[self.accountTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"x = %@",x);
//    }];
//    
//    
//    // 代理
//    
//    
//    // 通知
    
    
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

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
