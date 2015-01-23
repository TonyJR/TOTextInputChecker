//
//  UIView+SKYEXT.h
//  TOTextInputCheckerDemo
//
//  Created by thor on 15-01-23.
//  Copyright (c) 2012年 SDNX . All rights reserved.
//

#import "UIView+KeyboardExt.h"


@implementation UIView (KeyboardExt)


//隐藏View上的键盘
- (void)hideKeyboard{
    [[self getTextFieldWithFocus] resignFirstResponder];
}

//获取当前UIVew中,获得输入焦点的UITextField
-(UITextField *)getTextFieldWithFocus{
    UITextField *result = nil;
    NSArray *array = [self FilterSubView:[UITextField class]];
    for(UITextField *sub in array){
        if ([sub isFirstResponder]) {
            result = sub;
            break;
        }
    }
    return result;
}


//获取当前view下的所有指定subview,
- (NSArray *)FilterSubView:(Class)findClass{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    [self recuGetSubView:findClass array:array];
    return array;
}

//递归获取当前view下的指定subview
- (void)recuGetSubView:(Class)findClass array:(NSMutableArray *)array {
    
    //isKindOfClass: 类或子类;isMemberOfClass: 只是本类
    if([self isKindOfClass:findClass]) { 
        [array addObject:self];
    }else if ([[self subviews] count] > 0){
        for(UIView *sub in [self subviews]){
            [sub recuGetSubView:findClass array:array];//递归当前view的所有子view
        }
    }    
}

@end
