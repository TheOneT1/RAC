//
//  ViewController3.m
//  RAC
//
//  Created by fs_work on 2017/3/31.
//  Copyright © 2017年 fs_work. All rights reserved.
//

#import "ViewController3.h"

@interface ViewController3 ()

@end

@implementation ViewController3


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.redTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
    
        [self filterTextField:self.redTextField WithString:x];
        
    }];
    
    
    [self.grennTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        
        [self filterTextField:self.grennTextField WithString:x];
        
    }];
    
    
    [self.blueTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        
        [self filterTextField:self.blueTextField WithString:x];
        
    }];
    
  
    
    [[self.redTextField rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(__kindof UIControl * _Nullable x) {
      
        UITextField *tf = x;
        
        if ( [tf.text isEqualToString:@"1"]) {
            
            tf.text = @"1.0";
        }
        
        if (tf.text.length == 0) {
            
            tf.text = @"0.0";
        }
       
      
    }];

    
    RACSignal *redSignal =    [self blindSlider:self.redSlider textInput:self.redTextField];
    RACSignal *greenSignal =   [self blindSlider:self.greenSlider textInput:self.grennTextField];
    RACSignal *blueSignal =   [self blindSlider:self.blueSlider textInput:self.blueTextField];
    
    [[[RACSignal combineLatest:@[redSignal,greenSignal,blueSignal]] map:^id _Nullable(id  _Nullable value) {
        
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1];
        
    }] subscribeNext:^(id  _Nullable x) {
        
        dispatch_async(dispatch_get_main_queue(), ^{ // UI 更新
            
            self.dynamicColorView.backgroundColor = x;
        });
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
    // 双向绑定
-(RACSignal *)blindSlider:(UISlider *)slider textInput:(UITextField *)textField;{
    
    // [slider rac_newValueChannelWithNilValue:nil]; 返回最新的值
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
        
    RACChannelTerminal *signalText = [textField rac_newTextChannel];
   
    // 文本订阅 slider
    [signalText subscribe:signalSlider];
        
//   //slider 订阅 文本
//    [signalSlider subscribe:signalText];
       
        
        //slider 订阅 文本 (转化格式)
    [[signalSlider map:^id _Nullable(id  _Nullable value) {
        
              return [NSString stringWithFormat:@"%.02f",[value floatValue]];
        
        }] subscribe:signalText];
    
    
    // 这是是为了解决只改变一个值就可以渲染color 不需要3个只都改动才渲染
    
    RACSignal *textS = [textField rac_textSignal];

    
    return [[signalText merge:signalSlider] merge:textS];
}

    
-(void)filterTextField:(UITextField *)text WithString:(NSString *)x
{
    static NSInteger const maxIntegerLength=1;//最大整数位
    static NSInteger const maxFloatLength=2;//最大精确到小数位
    
    if (x.length) {
        //第一个字符处理
        //第一个字符为0,且长度>1时
        if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
            if (x.length>1) {
                
                
                if ([[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                    //如果第二个字符还是0,即"00",则无效,改为"0"
                    self.redTextField.text=@"0";
                }else if (![[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]){
                    //如果第二个字符不是".",比如"03",清除首位的"0"
                    self.redTextField.text=[x substringFromIndex:1];
                }
            }
        }
        //第一个字符为"."时,改为"0."
        else if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]){
            
            text.text=@"0.";
            
        }
        
        if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
            
            if (x.length > 1) {
                
                if ([[x substringWithRange:NSMakeRange(1, 1)] integerValue] >= 0)
                {
                    text.text = @"1";
                }
                
            }
        }
        
         if ([[x substringWithRange:NSMakeRange(0, 1)] integerValue] > 1)
         {
             text.text = @"";
         }
        
        //2个以上字符的处理
        NSRange pointRange = [x rangeOfString:@"."];
        NSRange pointsRange = [x rangeOfString:@".."];
        if (pointsRange.length>0) {
            //含有2个小数点
            text.text=[x substringToIndex:x.length-1];
        }
        else if (pointRange.length>0){
            //含有1个小数点时,并且已经输入了数字,则不能再次输入小数点
            if ((pointRange.location!=x.length-1) && ([[x substringFromIndex:x.length-1]isEqualToString:@"."])) {
                text.text=[x substringToIndex:x.length-1];
            }
            if (pointRange.location+maxFloatLength<x.length) {
                //输入位数超出精确度限制,进行截取
                text.text=[x substringToIndex:pointRange.location+maxFloatLength+1];
            }
        }
        else{
            if (x.length>maxIntegerLength) {
                text.text=[x substringToIndex:maxIntegerLength];
            }
        }
        
    }
    
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
