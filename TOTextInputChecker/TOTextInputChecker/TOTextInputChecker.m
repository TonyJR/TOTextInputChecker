//
//  TOTextInput.m
//  FrameworkTest
//
//  Created by Ted on 13-11-13.
//  Copyright (c) 2013年 Tony. All rights reserved.
//

#import "TOTextInputChecker.h"
#import "RegexKitLite.h"

#define IS_IOS7_OR_LATER        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)


@implementation TOTextInputChecker{
    NSString * fixedStrCopy;
}

@synthesize type,text,keyboardType;
@synthesize backgroundNomarl,backgroundHighlighted,backgroundError,backgroundErrorHighlighted,secureTextEntry;

-(id)init{
    self = [super init];
    if(self){
        self.maxLen = 30;
        self.minLen = 0;
        self.characters = @"[a-zA-Z0-9_]";
        self.keyboardType = UIKeyboardTypeDefault;
        self.type = InputCheckTypeString | InputCheckTypeCharacters | InputCheckTypeMaxLength | InputCheckTypeNotNull;
        self.text = @"";
        self.secureTextEntry = NO;
        self.backgroundNomarl = @"input_bg_nomarl_out";
        self.backgroundHighlighted = @"input_bg_nomarl_on";
        self.backgroundError = nil;
        self.backgroundErrorHighlighted = nil;
    }
    return self;
}

/**
 *  交易密码检查
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)passwordChecker{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = CusKeyboardTypeNumOnly;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | InputCheckTypeNotNull|InputCheckTypeCharacters;
    check.characters = @"[0-9]";
    check.maxLen = 6;
    check.minLen = 6;
    check.secureTextEntry = YES;
    
    return check;
}
/**
 *  登录密码
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)loginPasswordChecker
{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = CusKeyboardTypeDefault;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | InputCheckTypeNotNull|InputCheckTypeCharacters;
    check.characters = @"[0-9a-zA-Z_]";
    check.maxLen = 12;
    check.minLen = 6;
    check.secureTextEntry = YES;
    
    return check;
}
/**
 *  动态口令
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)codePasswordChecker
{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeNumberPad;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | InputCheckTypeNotNull|InputCheckTypeCharacters;
    check.characters = @"[0-9]";
    check.maxLen = 6;
    check.minLen = 6;
    
    return check;
}

+(TOTextInputChecker *)accountChecker
{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | InputCheckTypeNotNull|InputCheckTypeCharacters;
    check.characters = @"[0-9]";
    check.maxLen = 25;
    check.minLen = 6;
    
    return check;
}
/**
 *  手机号码检测
 *
 *  @param notNull 是否允许为空
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)telChecker:(BOOL) notNull{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeNumberPad;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | (notNull ? InputCheckTypeNotNull : 0);
    check.characters = @"[0-9]";
    check.regex = @"[1-9][0-9]{10}";
    check.maxLen = 11;
    check.minLen = 11;
    return check;
}
/**
 *  邮箱地址检查
 *
 *  @param notNull 是否允许为空
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)mailChecker:(BOOL)notNull{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeEmailAddress;
    check.type = InputCheckTypeString | InputCheckTypeMaxLength | InputCheckTypeMinLength | (notNull ? InputCheckTypeNotNull : 0);
    check.maxLen = 50;
    check.characters = @"[0-9a-zA-Z_.@]";
    check.regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    return check;
}
/**
 *  浮点型检查
 *
 *  @param min 最小值
 *  @param max 最大值
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)floatChecker:(float)min max:(float)max{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeDecimalPad;
    check.type = InputCheckTypeFloat | InputCheckTypeNotNull;
    check.characters = @"[0-9.]";
    
    check.maxLen = max;
    check.minLen = min;
    return check;
}
/**
 *  整型检查
 *
 *  @param min 最小值
 *  @param max 最大值
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)intChecker:(float)min max:(float)max{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeNumberPad;
    check.type = InputCheckTypeInt | InputCheckTypeNotNull;
    check.characters = @"[0-9.]";
    check.maxLen = 10000;
    check.minLen = 100;
    return check;
    
    
}

/**
 *  金额检查
 *
 *  @param min 最小值
 *  @param max 最大值
 *
 *  @return 检查器
 */
+(TOTextInputChecker *)moneyChecker:(float)min max:(float)max{
    TOTextInputChecker * check = [[TOTextInputChecker alloc] init];
    check.keyboardType = UIKeyboardTypeDecimalPad;
    check.type = InputCheckTypeMoney | InputCheckTypeNotNull;
    check.characters = @"[0-9.]";
    check.maxLen = max;
    check.minLen = min;
    return check;
}













-(BOOL)shouldChangeString:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    
#ifdef __IPHONE_7_0
    return YES;
#else
    return [self maxLengthCheck:input inRange:range replacementString:string] && [self charactersCheck:input inRange:range replacementString:string];
#endif
}



#pragma mark setters
-(void)setMaxLen:(CGFloat)maxLen{
    self.type |= InputCheckTypeMaxLength;
    _maxLen = maxLen;
}

-(void)setMinLen:(CGFloat)minLen{
    self.type |= InputCheckTypeMinLength;
    _minLen = minLen;
}

-(void)setCharacters:(NSString *)characters{
    self.type |= InputCheckTypeCharacters;
    _characters = characters;
}

-(void)setRegex:(NSString *)regex{
    self.type |= InputCheckTypeRegex;
    _regex = regex;
}

//字符集检测
-(BOOL)charactersCheck:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    return [self charactersCheck:string];
    
}
-(BOOL)charactersCheck :(NSString *)string{
    if(!(self.type & InputCheckTypeCharacters)){
        
        return YES;
    }
    if(self.characters==nil || self.characters.length==0 || string.length==0){
        
        return YES;
    }
    NSString * c = nil;
    for (int i = 0 ; i<string.length ; i++) {
        c = [string substringWithRange:NSMakeRange(i, 1)];
        
        if (![c isMatchedByRegex:self.characters]) {
            return NO;
        }
    }
    
    
    return YES;
    
}

//字符串最大检测
-(BOOL)maxLengthCheck:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    if (!(self.type & InputCheckTypeMaxLength)) {
        return YES;
    }
    //最大字符数
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([string length]==0) {
        
        return YES;
    }
    else {
        if ([lang isEqualToString:@"zh-Hans"] && [string isMatchedByRegex:@"[a-zA-Z]"] && [string length]==1) { //如果输入键盘为中文 并且输入的为字母，长度为1（中文输入条上全英文） 就算达到上限也是可以输入的
            
            return YES;
            
        }
        else{
            
            if ([[input text] length]+[string length]-range.length > self.maxLen){
                
                
                return NO;
            }
            else {
                
                return YES;
            }
        }
    }
}

//金额最大检测
-(BOOL)shouldChangeMoney:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    if (![self charactersCheck:input inRange:range replacementString:string]) {
        return NO;
    }
    
    NSArray * temp = [string arrayOfCaptureComponentsMatchedByRegex:@"[.]"];
    if (temp.count>1) {
        return NO;
    }
    if (temp.count>0) {
        if ([[input text] arrayOfCaptureComponentsMatchedByRegex:@"[.]"].count>0) {
            return NO;
        }
    }
    
    
    NSMutableString * str = [NSMutableString stringWithString:[input text]];
    [str  replaceCharactersInRange:range withString:string];
    
    
    NSRange r = [str rangeOfString:@"."];
    int loc = r.location;
    int pos = str.length - 3;
    if (loc != NSNotFound && loc != -1 && (loc < pos)) {
        return NO;
    }
    
    double floatValue = str.doubleValue;
    if (floatValue > self.maxLen) {
        floatValue = self.maxLen;
        
        self.text = [NSString stringWithFormat:@"%0.2f",floatValue];
        [input setText:self.text];
        return  NO;
    }else if (str.length==0) {
        if(self.type & InputCheckTypeNotNull){
            self.text = @"0";
            [input setText:self.text];
            return NO;
        }else{
            return YES;
        }
        
        
    }else if ([[input text] isEqualToString:@"0"]) {
        if ([string rangeOfString:@"."].location == 0) {
            self.text = [NSString stringWithFormat:@"0%@",string];
            [input setText:self.text];
        }else{
            self.text = string;
            [input setText:self.text];
        }
        return NO;
    }else if ([str rangeOfString:@"."].location == 0) {
        self.text = [NSString stringWithFormat:@"0%@",str];
        [input setText:self.text];
        return NO;
    }else{
        
        return YES;
    }
}
-(BOOL)shouldChangeFloat:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    if (![self charactersCheck:input inRange:range replacementString:string]) {
        return NO;
    }
    
    NSArray * temp = [string arrayOfCaptureComponentsMatchedByRegex:@"[.]"];
    if (temp.count>1) {
        return NO;
    }
    if (temp.count>0) {
        if ([[input text] arrayOfCaptureComponentsMatchedByRegex:@"[.]"].count>0) {
            return NO;
        }
    }
    
    
    NSMutableString * str = [NSMutableString stringWithString:[input text]];
    [str  replaceCharactersInRange:range withString:string];
    
    double floatValue = str.doubleValue;
    if (floatValue > self.maxLen) {
        floatValue = self.maxLen;
        
        self.text = [NSString stringWithFormat:@"%f",floatValue];
        [input setText:self.text];
        return  NO;
    }else if (str.length==0) {
        if(self.type & InputCheckTypeNotNull){
            self.text = @"0";
            [input setText:self.text];
            return NO;
        }else{
            return YES;
        }
    }else if ([[input text] isEqualToString:@"0"]) {
        if ([string rangeOfString:@"."].location == 0) {
            self.text = [NSString stringWithFormat:@"0%@",string];
            [input setText:self.text];
        }else{
            self.text = string;
            [input setText:self.text];
        }
        return NO;
    }else if ([str rangeOfString:@"."].location == 0) {
        self.text = [NSString stringWithFormat:@"0%@",str];
        [input setText:self.text];
        return NO;
    }else{
        
        return YES;
    }
}
-(BOOL)shouldChangeInt:(id)input inRange:(NSRange)range replacementString:(NSString *)string{
    if (![self charactersCheck:input inRange:range replacementString:string]) {
        return NO;
    }
    NSMutableString * str = [NSMutableString stringWithString:[input text]];
    [str  replaceCharactersInRange:range withString:string];
    
    if(str.length == 0 && !(self.type & InputCheckTypeNotNull)){
        
        return YES;
    }else{
        int intValue = str.intValue;
        intValue = MIN(intValue, self.maxLen);
        
        self.text = [NSString stringWithFormat:@"%d",intValue];
        [input setText:self.text];
        return  NO;
    }
    
    
}





-(enum InputCheckError)finalCheck{
    
    
    if(self.type & InputCheckTypeNotNull){
        if(self.text.length == 0){
            return InputCheckErrorNull;
        }
    }else if(self.text == nil || self.text.length == 0){
        return InputCheckErrorNone;
    }
    
    if (self.type &  InputCheckTypeMinLength) {
        
        if (self.type & 0xf) {
            if([self.text floatValue] < self.minLen){
                return InputCheckErrorSmall;
            }
            
        }else{
            if(self.text.length < self.minLen){
                if (self.minLen == self.maxLen) {
                    return InputCheckErrorOnlyLength;
                }else{
                    return InputCheckErrorShot;
                }
                
            }
        }
    }
    
    if (self.type & InputCheckTypeRegex) {
        if (self.regex && self.regex.length > 0) {
            if (![self.text isMatchedByRegex:self.regex]) {
                return InputCheckErrorRegex;
            }
        }
        
    }
    
    return InputCheckErrorNone;
    
}

-(id)copy{
    TOTextInputChecker * result = [[self.class alloc] init];
    result.type = self.type;
    result.maxLen = self.maxLen;
    result.minLen = self.minLen;
    result.characters = self.characters;
    result.text = self.text;
    result.keyboardType = self.keyboardType;
    result.regex = self.regex;
    result.backgroundHighlighted = self.backgroundHighlighted;
    result.backgroundNomarl = self.backgroundNomarl;
    result.backgroundError = self.backgroundError;
    result.backgroundErrorHighlighted = self.backgroundErrorHighlighted;
    result.secureTextEntry = self.secureTextEntry;
    return result;
}



#pragma mark xDelegate
- (void)xDidBeginEditing:(id)x{
    
    
    if (self.backgroundHighlighted) {
        if (self.backgroundErrorHighlighted && [self finalCheck] != InputCheckErrorNone) {
            [x setBackground:[UIImage imageNamed:self.backgroundErrorHighlighted]];
        }else{
            [x setBackground:[UIImage imageNamed:self.backgroundHighlighted]];
        }
    }
    
    [x setSecureTextEntry:self.secureTextEntry];
    
#ifdef __IPHONE_7_0
    fixedStrCopy = [x text];
    
    [x addTarget:self action:@selector(xDidChange:) forControlEvents:UIControlEventEditingChanged];
#endif
}
- (void)xDidEndEditing:(id)x{
    
    if (self.backgroundNomarl) {
        if (self.backgroundError && [self finalCheck] != InputCheckErrorNone) {
            [x setBackground:[UIImage imageNamed:self.backgroundError]];
        }else{
            [x setBackground:[UIImage imageNamed:self.backgroundNomarl]];
        }
    }
    
    if ([x text].length != 0  || (self.type & InputCheckTypeNotNull)) {
        
        switch (self.type & 0x0f) {
            case InputCheckTypeFloat:{
                double r = [[x text] doubleValue];
                if (r < self.minLen) {
                    r = self.minLen;
                }
                [x setText:[NSString stringWithFormat:@"%f",r]];
                break;
            }
            case InputCheckTypeInt:{
                int r =[x text].intValue;
                if (r < self.minLen) {
                    r = self.minLen;
                }
                [x setText:[NSString stringWithFormat:@"%d",r]];
                break;
            }
            case InputCheckTypeMoney:{
                double r = [[x text] doubleValue];
                if (r < self.minLen) {
                    r = self.minLen;
                }
                
                [x setText:[NSString stringWithFormat:@"%0.2f",r]];
                break;
            }
        }
    }
    self.text = [x text];
    [x setSecureTextEntry:self.secureTextEntry];
    
#ifdef __IPHONE_7_0
    fixedStrCopy = nil;
    [x removeTarget:self action:@selector(xDidChange:) forControlEvents:UIControlEventEditingChanged];
#endif
}

//文本修改时调，ios7以后版本调用
-(void)xDidChange:(id)input{
    
    @synchronized(self){
        
        UITextRange * range = [input markedTextRange];
        if (!range) {
            //非字符类型时退出
            if(!(self.type & InputCheckTypeCharacters)){
                return;
            }
            
            //输入字符检测失败时修复
            if (![self charactersCheck:[input text]]) {
                
                [input setText:fixedStrCopy];
                //[input performSelector:@selector(setText:) withObject:fixedStrCopy afterDelay:0.01];
                return;
            }
            //非字符长度限制时退出
            if (!(self.type & InputCheckTypeMaxLength)) {
                return ;
            }
            //字符长度检测失败时修复
            if ([input text].length > self.maxLen) {
                [input setText:fixedStrCopy];
                
                //[input performSelector:@selector(setText:) withObject:fixedStrCopy afterDelay:0.01];
                
                return;
            }
            
            fixedStrCopy = [input text];
        }else{
            
            range = [input textRangeFromPosition:[input beginningOfDocument] toPosition:range.start];
            fixedStrCopy = [input textInRange:range];
            
        }
    }
}

-(void)textFallBack:(id)input {
    @synchronized(self){
        [input setText:fixedStrCopy];
    }
}

- (BOOL)x:(id)x shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL result = YES;
    
    switch (self.type & 0x0f) {
        case InputCheckTypeString:
            
            result = [self shouldChangeString:x inRange:range replacementString:string];
            break;
        case InputCheckTypeFloat:
            result = [self shouldChangeFloat:x inRange:range replacementString:string];
            break;
        case InputCheckTypeInt:
            result = [self shouldChangeInt:x inRange:range replacementString:string];
            break;
        case InputCheckTypeMoney:
            result = [self shouldChangeMoney:x inRange:range replacementString:string];
            break;
        default:
            break;
    }
    
    
    if (result) {
        
        NSMutableString * str = [NSMutableString stringWithString:[x text]];
        [str  replaceCharactersInRange:range withString:string];
        
        
        self.text = str;
        
        
        if (self.backgroundErrorHighlighted && self.backgroundHighlighted) {
            if ([self finalCheck] == InputCheckErrorNone) {
                [x setBackground:[UIImage imageNamed:self.backgroundHighlighted]];
            }else{
                [x setBackground:[UIImage imageNamed:self.backgroundErrorHighlighted]];
            }
        }
    }
    
    return result;
}



- (BOOL)xShouldBeginEditing:(id<UITextInput>)x{
    [x setKeyboardType:self.keyboardType];
    return YES;
}

- (BOOL)xShouldEndEditing:(id)x{
    self.text = [x text];
    return YES;
}
- (BOOL)xShouldClear:(id)x{
    
    return YES;
}
- (BOOL)xShouldReturn:(id)x{
    [x resignFirstResponder];
    return YES;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
    [self xDidBeginEditing:textField];
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self xDidEndEditing:textField];
    if (self.delegate) {
        [self.delegate performSelector:@selector(pickerDidChanged:) withObject:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self x:textField shouldChangeCharactersInRange:range replacementString:string];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return [self xShouldBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return [self xShouldEndEditing:textField];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return [self xShouldClear:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self xShouldReturn:textField];
}


#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self xDidBeginEditing:textView];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self xDidEndEditing:textView];
    if (self.delegate) {
        [self.delegate performSelector:@selector(pickerDidChanged:) withObject:self];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string{
    return [self x:textView shouldChangeCharactersInRange:range replacementString:string];
}




- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return [self xShouldBeginEditing:textView];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return [self xShouldEndEditing:textView];
}
- (BOOL)textViewShouldClear:(UITextView *)textView{
    return [self xShouldClear:textView];
}
- (BOOL)textViewShouldReturn:(UITextView *)textView{
    return [self xShouldReturn:textView];
}

@end