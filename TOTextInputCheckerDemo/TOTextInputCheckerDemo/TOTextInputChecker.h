//
//  TOTextInput.h
//  TOTextInputChecker
//
//  Created by Tony on 13-11-13.
//  Copyright (c) 2013年 SDNX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputError.h"

enum InputCheckType{
    //非兼容模式
    InputCheckTypeString = 0x00,
    InputCheckTypeFloat = 0x01,
    InputCheckTypeInt = 0x02,
    InputCheckTypeMoney = 0x04,
    
    
    /*兼容模式*/
    //字符模式下表示字符长度,数字长度下表示最大值
    InputCheckTypeMaxLength = 0x10,
    InputCheckTypeMinLength = 0x20,
    InputCheckTypeNotNull = 0x40,
    //输入字符集限制模式
    InputCheckTypeCharacters = 0x80,
    //文本合法性检测
    InputCheckTypeRegex = 0x100,
    
};

enum KeyboardType
{
    SysKeyboardTypeDefault = UIKeyboardTypeDefault,
    SysKeyboardTypeASCIICapable = UIKeyboardTypeASCIICapable,
    SysKeyboardTypeNumbersAndPunctuation = UIKeyboardTypeNumbersAndPunctuation,
    SysKeyboardTypeURL = UIKeyboardTypeURL,
    SysKeyboardTypeNumberPad = UIKeyboardTypeNumberPad,
    SysKeyboardTypePhonePad = UIKeyboardTypePhonePad,
    SysKeyboardTypeNamePhonePad = UIKeyboardTypeNamePhonePad,
    SysKeyboardTypeEmailAddress = UIKeyboardTypeEmailAddress,
    SysKeyboardTypeDecimalPad = UIKeyboardTypeDecimalPad,    //  NS_ENUM_AVAILABLE_IOS(4_1)
    SysKeyboardTypeTwitter = UIKeyboardTypeTwitter,  // NS_ENUM_AVAILABLE_IOS(5_0)
    SysKeyboardTypeWebSearch = UIKeyboardTypeWebSearch,  // NS_ENUM_AVAILABLE_IOS(7_0)
    SysKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable, // Deprecated
    
    // 自定义
    CusKeyboardTypeDefault = 12,
    CusKeyboardTypeNumOnly = 13,
};


@class TOTextInputChecker;


@protocol TOTextInputCheckerDelegate <NSObject>

@required

-(void)pickerDidChanged:(TOTextInputChecker *)picker;

@end


@interface TOTextInputChecker : NSObject<UITextFieldDelegate,UITextViewDelegate>{
    enum InputCheckType type;
}


@property (nonatomic) enum InputCheckType type;
@property (nonatomic, strong)   NSString * characters;
@property (nonatomic, strong)   NSString * regex;
@property (nonatomic) enum KeyboardType   keyboardType;

@property (nonatomic)   CGFloat  maxLen;
@property (nonatomic)   CGFloat  minLen;

@property (nonatomic)   NSString *  text;
@property (nonatomic)   BOOL secureTextEntry;

@property (nonatomic,weak) id<TOTextInputCheckerDelegate> delegate;

//背景图片
@property (nonatomic,strong) NSString * backgroundNomarl;
@property (nonatomic,strong) NSString * backgroundHighlighted;
@property (nonatomic,strong) NSString * backgroundError;
@property (nonatomic,strong) NSString * backgroundErrorHighlighted;


-(id)copy;

-(BOOL)shouldChangeString:(id)input inRange:(NSRange)range replacementString:(NSString *)string;
-(BOOL)shouldChangeMoney:(id)input inRange:(NSRange)range replacementString:(NSString *)string;
-(BOOL)shouldChangeFloat:(id)input inRange:(NSRange)range replacementString:(NSString *)string;
-(BOOL)shouldChangeInt:(id)input inRange:(NSRange)range replacementString:(NSString *)string;


-(enum InputCheckError)finalCheck;

+(TOTextInputChecker *)passwordChecker;
+(TOTextInputChecker *)codePasswordChecker;
+(TOTextInputChecker *)loginPasswordChecker;
+(TOTextInputChecker *)accountChecker;
+(TOTextInputChecker *)telChecker:(BOOL)notNull;
+(TOTextInputChecker *)mailChecker:(BOOL)notNull;
+(TOTextInputChecker *)floatChecker:(float)min max:(float)max;
+(TOTextInputChecker *)intChecker:(float)min max:(float)max;
+(TOTextInputChecker *)moneyChecker:(float)min max:(float)max;

@end

#define CODE_CHECKER     [TOTextInputChecker codePasswordChecker]
#define PASSWORD_CHECKER [TOTextInputChecker passwordChecker]
#define TEL_CHECKER_NOT_NULL [TOTextInputChecker telChecker:YES]
#define TEL_CHECKER [TOTextInputChecker telChecker:NO]
#define ACCOUNT_CHECKER  [TOTextInputChecker accountChecker]

// 2014.08.26
#define LOGIN_PASSWORD_CHECKER  [TOTextInputChecker loginPasswordChecker]

#define MONEY_CHECKER  [TOTextInputChecker moneyChecker:0 max:999999999999.99]


