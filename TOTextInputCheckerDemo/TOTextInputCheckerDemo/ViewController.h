//
//  ViewController.h
//  TOTextInputCheckerDemo
//
//  Created by Tony on 14-5-22.
//  Copyright (c) 2014年 SDNX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextFieldPadding.h"

@interface ViewController : UIViewController


@property (nonatomic,strong) IBOutlet UITextFieldPadding * text1;
@property (nonatomic,strong) IBOutlet UITextFieldPadding * text2;
@property (nonatomic,strong) IBOutlet UITextFieldPadding * text3;
@property (nonatomic,strong) IBOutlet UITextFieldPadding * text4;
@property (nonatomic,strong) IBOutlet UITextFieldPadding * text5;


-(IBAction)touchDownHandler:(id)sender;
@end
