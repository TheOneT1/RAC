//
//  ViewController.m
//  RAC
//
//  Created by fs_work on 2017/3/31.
//  Copyright © 2017年 fs_work. All rights reserved.
//


#import "ViewController.h"
#define VIEWHEIGHT self.view.frame.size.height - 64

typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshPull = 1,
    RefreshLift = 2,
    RefreshCommon = 0
    
};

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
    {
        UIRefreshControl *_freshControl;
        UIButton *btn;
        
        CGFloat *_lastY;
    }
    
@end

@implementation ViewController
    

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.frame.size.width - 80 , VIEWHEIGHT - 80 , 60, 60);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
  
    [[[RACObserve(self.tableView, contentOffset) map:^id _Nullable(id  _Nullable value) {
        
        return @(self.tableView.contentOffset.y);
        
    }] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {

        
        NSLog(@"x == %@",x);
    }];
    
    
    
    
    /*
     
       CGFloat spacing = 50;
    
    [[[RACObserve(self.tableView, contentOffset) map:^id _Nullable(id  _Nullable value) {
        
        if (self.tableView.contentOffset.y < - spacing) {
            
            return @(RefreshPull);
        }
        
        if (self.tableView.contentOffset.y + VIEWHEIGHT > self.tableView.contentSize.height +spacing ) {
            
            return @(RefreshLift);
            
        }else{
            
            return @(RefreshCommon);
        }
    }] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        
        
        NSLog(@"x = %@",x);
        
        if ([x integerValue] == 0) {
            
        }
        
        if ([x integerValue] == RefreshPull) {
            
            NSLog(@"下拉刷新");
            [self showButton];
            
        }else if ([x integerValue] == RefreshLift){
            
            [self hideButton];
            NSLog(@"上拉加载更多");
            
            
        }
    }];
     */
}

- (void)hideButton
{
    [UIView animateWithDuration:0.35 animations:^{
        
        [btn setFrame:CGRectMake(self.view.frame.size.width - 80 , VIEWHEIGHT + 64, 60, 60)];
    }];
    
}
-(void)showButton
{
    [UIView animateWithDuration:0.35 animations:^{
        
        [btn setFrame:CGRectMake(self.view.frame.size.width - 80 , VIEWHEIGHT - 84, 60, 60)];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    
{
    return 15;
    
}
    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%zd行",indexPath.row];
        
        return cell;
    }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        return 55;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
    {
        return 0.01;
        
    }
    
    -(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
    {

        return 0.01;
    }

@end
