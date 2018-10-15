//
//  LimitInput.m
//  singleview
//
//  Created by aqua on 14-8-30.
//  Copyright (c) 2014年 aqua. All rights reserved.
//

#import "LimitInput.h"
#import <objc/runtime.h>
#import "JZStringMacrocDefine.h"


#define RUNTIME_ADD_PROPERTY(propertyName)      \
-(id)valueForUndefinedKey:(NSString *)key {     \
if ([key isEqualToString:propertyName]) {   \
return objc_getAssociatedObject(self, key.UTF8String);  \
}                                           \
return nil;                                 \
}                                               \
-(void)setValue:(id)value forUndefinedKey:(NSString *)key { \
if ([key isEqualToString:propertyName]) {               \
objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN); \
}                                                       \
}

#define IMPLEMENT_PROPERTY(className) \
@implementation className (Limit) RUNTIME_ADD_PROPERTY(PROPERTY_NAME) @end

IMPLEMENT_PROPERTY(UITextField)
IMPLEMENT_PROPERTY(UITextView)

@implementation LimitInput


+(void) load {
    [super load];
    [LimitInput sharedInstance];
}
    
    
+(LimitInput *) sharedInstance {
    static LimitInput *g_limitInput;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        g_limitInput = [[LimitInput alloc] init];
        g_limitInput.enableLimitCount = YES;
    });
    
    return g_limitInput;
}
    
-(id) init {
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidChange:) name:UITextFieldTextDidChangeNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object: nil];
    }
    
    return self;
}

    
-(void)textFieldViewDidChange:(NSNotification*)notification {
    if (!self.enableLimitCount) return;
    UITextField *textField = (UITextField *)notification.object;
    
    NSNumber *number = [textField valueForKey:PROPERTY_NAME];
    
    if (number) {
        
        NSString *toBeString = textField.text;
        
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        //没有高亮选择的字, 则对已经输入的文字进行字数统计
        if (!position||!selectedRange) {
            if (toBeString.length <[number integerValue] ) {
                
                textField.textField_isMore = [NSNumber numberWithBool:YES];
                
                if (JZStringIsContainsEmoji(textField.text)) {
                    if (toBeString.length>textField.textField_tempText.length) {
                        textField.text=textField.textField_tempText;
                    }else{
                        textField.text=@"";
                        textField.textField_tempText = @"";
                    }
                }else{
                    if (JZStringIsContainsEmoji(textField.text)) {
                        if (toBeString.length>textField.textField_tempText.length) {
                            textField.text=textField.textField_tempText;
                        }else{
                            textField.text=@"";
                            textField.textField_tempText = @"";
                        }
                    }else{
                        textField.textField_tempText = textField.text;
                    }
                }
            }else if (toBeString.length == [number integerValue]){
                textField.textField_isMore = [NSNumber numberWithBool:NO];
                if (JZStringIsContainsEmoji(textField.text)) {
                    if (toBeString.length>textField.textField_tempText.length) {
                        textField.text=textField.textField_tempText;
                    }else{
                        textField.text=@"";
                        textField.textField_tempText = @"";
                    }
                }else{
                    textField.textField_tempText = textField.text;
                }
            } else {
                //            if ([number integerValue] > 20) {
                //                [JZAlertHUD autoShowMessage:@"已达到字数上限"];
                //            }
                
                if ( [textField.textField_isMore boolValue] || JZStringIsNull(textField.text)) {
                    textField.text = [toBeString substringToIndex:[number integerValue]];
                    textField.textField_isMore = [NSNumber numberWithBool:NO];
                }else{
                    textField.text =  textField.textField_tempText;
                }
                if (JZStringIsContainsEmoji(textField.text)) {
                    if (toBeString.length>textField.textField_tempText.length) {
                        textField.text=textField.textField_tempText;
                    }else{
                        textField.text=@"";
                        textField.textField_tempText = @"";
                    }
                }else{
                    if (JZStringIsContainsEmoji(textField.text)) {
                        if (toBeString.length>textField.textField_tempText.length) {
                            textField.text=textField.textField_tempText;
                        }else{
                            textField.text=@"";
                            textField.textField_tempText = @"";
                        }
                    }else{
                        textField.textField_tempText = textField.text;
                    }
                }
            }
            
        }
    }
    if (textField.delegate && [textField.delegate respondsToSelector:@selector(jz_textFieldViewDidChange:)]) {
        id <JZTextFieldDelegate> delegate = (id <JZTextFieldDelegate>)textField.delegate;
        [delegate jz_textFieldViewDidChange:textField];
    }
    
}


-(void) textViewDidChange: (NSNotification *) notificaiton {
    if (!self.enableLimitCount) return;
    UITextView *textView = (UITextView *)notificaiton.object;
    
    NSNumber *number = [textView valueForKey:PROPERTY_NAME];
    
    if (number) {
        UITextRange *selectedRange = [textView markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        //没有高亮选择的字, 则对已经输入的文字进行字数统计
        if (!position & !selectedRange) {
            NSString *toBeString = textView.text;
            
            if (toBeString.length < [number integerValue] ) {
                textView.textView_isMore = [NSNumber numberWithBool:YES];
                if (JZStringIsContainsEmoji(textView.text)) {
                    if (toBeString.length>textView.textView_tempText.length) {
                        textView.text=textView.textView_tempText;
                    }else{
                        textView.text=@"";
                        textView.textView_tempText = @"";
                    }
                }else{
                    textView.textView_tempText = textView.text;
                }
            }else if (toBeString.length == [number integerValue]){
                textView.textView_isMore = [NSNumber numberWithBool:NO];
                
                if (JZStringIsContainsEmoji(textView.text)) {
                    if (toBeString.length>textView.textView_tempText.length) {
                        textView.text=textView.textView_tempText;
                    }else{
                        textView.text=@"";
                        textView.textView_tempText = @"";
                    }
                    
                }else{
                    textView.textView_tempText = textView.text;
                }
            }else {
                
                if ( [textView.textView_isMore boolValue] || JZStringIsNull(textView.text)) {
                    
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:[number integerValue]];
                    if (rangeIndex.length == 1){
                        textView.text = [toBeString substringToIndex:[number integerValue]];
                    }else{
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, [number integerValue])];
                        textView.text = [toBeString substringWithRange:rangeRange];
                    }
                    //                textField.text = [toBeString substringToIndex:[number integerValue]];
                    textView.textView_isMore = [NSNumber numberWithBool:NO];
                }else{
                    textView.text =  textView.textView_tempText;
                }
                
                if (JZStringIsContainsEmoji(textView.text)) {
                    if (toBeString.length>textView.textView_tempText.length) {
                        textView.text=textView.textView_tempText;
                    }else{
                        textView.text=@"";
                        textView.textView_tempText = @"";
                    }
                }else{
                    textView.textView_tempText = textView.text;
                }
            }
        }
        
    }
    if (textView.delegate && [textView.delegate respondsToSelector:@selector(jz_textViewDidChange:)]) {
        id <JZTextViewDelegate> delegate = (id <JZTextViewDelegate>)textView.delegate;
        [delegate jz_textViewDidChange:textView];
    }

}



@end




static const char *JZTextField_textField_isMore = "JZTextField_textField_isMore";
static const char *JZTextField_textField_tempText = "JZTextField_textField_tempText";

@implementation UITextField (JZTextField)


- (void)setTextField_isMore:(NSNumber *)textField_isMore{
    objc_setAssociatedObject(self, JZTextField_textField_isMore, textField_isMore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (NSNumber *)textField_isMore{
    NSNumber * textField_isMoreNumber = objc_getAssociatedObject(self, JZTextField_textField_isMore);
    if (textField_isMoreNumber  == nil) {
        return [NSNumber numberWithBool:YES];
    }
    return textField_isMoreNumber;
}

- (void)setTextField_tempText:(NSString *)textField_tempText{
    objc_setAssociatedObject(self, JZTextField_textField_tempText, textField_tempText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (NSString *)textField_tempText{
    NSString * textField_tempText = objc_getAssociatedObject(self, JZTextField_textField_tempText);
    
    return textField_tempText;
}


@end



static const char *JZTextView_textField_isMore = "JZTextView_textField_isMore";
static const char *JZTextView_textField_tempText = "JZTextView_textField_tempText";

@implementation UITextView (JZTextView)


- (void)setTextView_isMore:(NSNumber *)textView_isMore{
    objc_setAssociatedObject(self, JZTextView_textField_isMore, textView_isMore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (NSNumber *)textView_isMore{
    NSNumber * textView_isMore = objc_getAssociatedObject(self, JZTextView_textField_isMore);
    if (textView_isMore  == nil) {
        return [NSNumber numberWithBool:YES];
    }
    return textView_isMore;
}

- (void)setTextView_tempText:(NSString *)textView_tempText{
    objc_setAssociatedObject(self, JZTextView_textField_tempText, textView_tempText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (NSString *)textView_tempText{
    NSString * textView_tempText = objc_getAssociatedObject(self, JZTextView_textField_tempText);
    
    return textView_tempText;
}



@end
