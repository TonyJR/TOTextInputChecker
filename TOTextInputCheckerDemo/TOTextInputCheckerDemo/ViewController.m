//
//  ViewController.m
//  TOTextInputCheckerDemo
//
//  Created by Tony on 14-5-22.
//  Copyright (c) 2014年 PY. All rights reserved.
//

#import "ViewController.h"
#import "TOTextInputChecker.h"
#import "UITextView+background.h"

@interface ViewController (){
    TOTextInputChecker * checker1;
    TOTextInputChecker * checker2;
    TOTextInputChecker * checker3;
    TOTextInputChecker * checker4;
    TOTextInputChecker * checker5;
    TOTextInputChecker * checker6;
}

@end

@implementation ViewController

@synthesize text1,text2,text3,text4,text5;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [(UIScrollView *)self.view setContentSize:CGSizeMake(0, 1000)];
    
    //邮箱检测
    checker1 = [TOTextInputChecker mailChecker:YES];
    //设置背景
    checker1.backgroundNomarl = @"input_bg_nomarl_out.png";
    checker1.backgroundHighlighted = @"input_bg_nomarl_on.png";
    checker1.backgroundError = @"input_bg_error_out.png";
    checker1.backgroundErrorHighlighted = @"input_bg_error_on.png";
    
    self.text1.delegate = checker1;
    [self.text1 setBackground:[UIImage imageNamed:@"input_bg_nomarl_out.png"]];
    //设置文本偏移
    [self.text1 setPadding:YES top:0 right:8 bottom:0 left:8];
    
    //密码检查
    checker2 = [TOTextInputChecker passwordChecker];
    
    checker2.backgroundNomarl = @"input_bg_nomarl_out.png";
    checker2.backgroundHighlighted = @"input_bg_nomarl_on.png";
    checker2.backgroundError = @"input_bg_error_out.png";
    checker2.backgroundErrorHighlighted = @"input_bg_error_on.png";
    
    
    self.text2.delegate = checker2;
    [self.text2 setBackground:[UIImage imageNamed:@"input_bg_nomarl_out.png"]];
    [self.text2 setPadding:YES top:0 right:8 bottom:0 left:8];
    
    //中文检查
    checker3 = [[TOTextInputChecker alloc] init];
    checker3.maxLen = 10;
    checker3.minLen = 4;
    checker3.characters = nil;
    
    checker3.backgroundNomarl = @"input_bg_nomarl_out.png";
    checker3.backgroundHighlighted = @"input_bg_nomarl_on.png";
    checker3.backgroundError = @"input_bg_error_out.png";
    checker3.backgroundErrorHighlighted = @"input_bg_error_on.png";
    self.text3.delegate = checker3;
    [self.text3 setBackground:[UIImage imageNamed:@"input_bg_nomarl_out.png"]];
    [self.text3 setPadding:YES top:0 right:8 bottom:0 left:8];
    
    //整型检查
    checker4 = [TOTextInputChecker intChecker:100 max:10000];
    
    checker4.backgroundNomarl = @"input_bg_nomarl_out.png";
    checker4.backgroundHighlighted = @"input_bg_nomarl_on.png";
    checker4.backgroundError = @"input_bg_error_out.png";
    checker4.backgroundErrorHighlighted = @"input_bg_error_on.png";
    self.text4.delegate = checker4;
    [self.text4 setBackground:[UIImage imageNamed:@"input_bg_nomarl_out.png"]];
    [self.text4 setPadding:YES top:0 right:8 bottom:0 left:8];
    
    //金额检查
    checker5 = [TOTextInputChecker moneyChecker:100 max:10000];
    
    checker5.backgroundNomarl = @"input_bg_nomarl_out.png";
    checker5.backgroundHighlighted = @"input_bg_nomarl_on.png";
    checker5.backgroundError = @"input_bg_error_out.png";
    checker5.backgroundErrorHighlighted = @"input_bg_error_on.png";
    self.text5.delegate = checker5;
    [self.text5 setBackground:[UIImage imageNamed:@"input_bg_nomarl_out.png"]];
    [self.text5 setPadding:YES top:0 right:8 bottom:0 left:8];
    
    
    
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
