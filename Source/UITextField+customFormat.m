//
//  UITextField+customFormat.m
//  Test
//
//  Created by 子瞻 on 2016/12/20.
//  Copyright © 2016年 jamesfeng. All rights reserved.
//

#import "UITextField+customFormat.h"
#import <objc/runtime.h>

static char *kPropertyTextBeforeEditing;

@interface UITextField()<UITextFieldDelegate>

@property (nonatomic, copy) NSString *textBeforeEditing;

@end

@implementation UITextField (customFormat)

- (void)setTextBeforeEditing:(NSString *)textBeforeEditing
{
    objc_setAssociatedObject(self, &kPropertyTextBeforeEditing, textBeforeEditing, OBJC_ASSOCIATION_COPY);
}

- (NSString *)textBeforeEditing
{
    return objc_getAssociatedObject(self, &kPropertyTextBeforeEditing);
}

#pragma mark - outer reference
- (void)setHasSpaceEveryFourDigits
{
    [self addTarget:self action:@selector(valueDidChanged) forControlEvents:UIControlEventValueChanged];
    [self addTarget:self action:@selector(editingChanged) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - handle event
//  记录上次编辑之后的字符串
- (void)valueDidChanged
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTextBeforeEditing:self.text];
    });
}

//  本次编辑时调用格式化方法
- (void)editingChanged
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self actionFormatString];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    });
}

- (void)actionFormatString
{
    NSString *textBeforeAction = self.textBeforeEditing;
    NSString *textAfterAction = self.text;
    NSString *textFormatted = [self stringOfSpaceEveryFourDigitsFromOriginalString:textAfterAction];
    
    //  记录编辑过后的光标位置，供下面调用，因为调用过[setText]方法之后光标位置会自动放到末位；
    NSRange range = [self selectedRange];
    
    //  如果本次编辑是输入而不是删除，并且输入之前光标的位置在某段4位号码的尾部，则光标相应的需要向后移动一位(空格影响)；
    if (textAfterAction.length > textBeforeAction.length && range.location > 4) {
        if (range.location - 5 + 4 <= textBeforeAction.length) {
            NSString *formerString = [textBeforeAction substringWithRange:NSMakeRange(range.location-5, 4)];
            if (![formerString containsString:@" "]) {
                range = NSMakeRange(range.location + 1, 0);
            }
        }
    }
    
    //  如果光标的位置超过了字符串长度，设置光标位置到末位(删除时会出现这种情况)；
    if (range.location > textFormatted.length) {
        range = NSMakeRange(textFormatted.length, 0);
    }
    
    //  设置格式化之后的字符串，将光标移到指定位置；
    [self setText:textFormatted];
    [self setSelectedRange:range];
}

#pragma mark - format string
- (NSString *)stringOfSpaceEveryFourDigitsFromOriginalString:(NSString *)rawString
{
    //  将源字符串中的空格全部移除
    NSString *normalString = [rawString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *resultString = [NSMutableString stringWithString:normalString];
    
    //  每四位插入1个空格
    for (NSInteger i=0; i<resultString.length/5; i++) {
        [resultString insertString:@" " atIndex:i*5+4];
    }
    
    return resultString;
}

#pragma mark - set textRange and get textRange
- (void) setSelectedRange:(NSRange) range
{
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

- (NSRange) selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

@end
