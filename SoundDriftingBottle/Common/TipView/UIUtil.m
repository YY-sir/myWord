//
//  UIUtil.m
//
//  Created by YY on 21/2/24.
//  Copyright (c) 2021年 yiyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIUtil.h"
#import "TTTipView.h"

@interface UIUtil ()

@end

static NSArray<NSString*>* stringFormatChoiceArr = nil;
static NSArray<NSString*>* numberFormatArr = nil;
static UITextView *textViewForHeightCalculation = nil;
static int eachStepStringFormatChoice[3][3] = {{StringFormatChoice_lowk,StringFormatChoice_loww,StringFormatChoice_lowkw},{StringFormatChoice_CapK,StringFormatChoice_CapW,StringFormatChoice_CapKW},{StringFormatChoice_ChineseK,StringFormatChoice_ChineseW,StringFormatChoice_ChineseKW}};

@implementation UIUtil

+ (void)initialize {
    textViewForHeightCalculation = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    textViewForHeightCalculation.textContainer.lineFragmentPadding = 0;
    textViewForHeightCalculation.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    numberFormatArr = @[@"%.0f",@"%.1f",@"%.2f",@"%.3f",@"%.4f",@"%.5f",@"%.6f",@"%.7f"];
    stringFormatChoiceArr = @[@"k", @"K", @"千", @"w", @"W", @"万",@"kw",@"KW",@"千万"];
}

+ (void)showHint:(NSString *)text {
    [UIUtil showHint:text inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showHint:(NSString *)text isBlockUser:(BOOL)isBlockUser {
    [UIUtil showHint:text inView:[UIApplication sharedApplication].keyWindow isBlockUser:isBlockUser];
}

+ (void)showHint:(NSString *)text inView:(UIView *)view {
    TTTipView *tipView = [TTTipView tipViewWithType:TTTipViewTypeTextHint];
    TTTipViewAnimationOptions options = TTTipViewAnimationOptionFadeInOut | TTTipViewAnimationOptionScaleInOut | TTTipViewAnimationOptionGrowth;
    [tipView setText:text];
    [tipView showInView:view animated:YES animationOptions:options];
}

+ (void)showHint:(NSString *)text inView:(UIView *)view isBlockUser:(BOOL)isBlockUser {
    TTTipView *tipView = [TTTipView tipViewWithType:TTTipViewTypeTextHint blockUserInteract:isBlockUser];
    TTTipViewAnimationOptions options = TTTipViewAnimationOptionFadeInOut | TTTipViewAnimationOptionScaleInOut | TTTipViewAnimationOptionGrowth;
    [tipView setText:text];
    [tipView showInView:view animated:YES animationOptions:options];
}

+ (void)showAttributedHint:(NSAttributedString *)text {
    [UIUtil showAttributedHint:text inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showAttributedHint:(NSAttributedString *)text inView:(UIView *)view {
    TTTipView *tipView = [TTTipView tipViewWithType:TTTipViewTypeTextHint];
    TTTipViewAnimationOptions options = TTTipViewAnimationOptionFadeInOut | TTTipViewAnimationOptionScaleInOut | TTTipViewAnimationOptionGrowth;
    [tipView setAttributedText:text];
    [tipView showInView:view animated:YES animationOptions:options];
}

+ (void)showLoading {
    [UIUtil showLoadingWithText:nil];
}

+ (void)showLoadingWithText:(NSString *)text {
    [UIUtil showLoadingWithText:text inView:[UIApplication sharedApplication].keyWindow];
}

+(void)showLoadingWithView:(UIView*)view{
    TTTipView *tipView = [TTTipView tipViewWithType:TTTipViewTypeLoading];
    TTTipViewAnimationOptions options = TTTipViewAnimationOptionFadeInOut | TTTipViewAnimationOptionScaleInOut | TTTipViewAnimationOptionGrowth;
    [tipView addSubview:view];
    view.center = tipView.center;
    [tipView showInView:[UIApplication sharedApplication].keyWindow animated:YES animationOptions:options];
}

+ (void)showLoadingWithText:(NSString *)text inView:(UIView *)view {
    
    TTTipView *tipView = [TTTipView tipViewWithType:TTTipViewTypeLoading];
    TTTipViewAnimationOptions options = TTTipViewAnimationOptionFadeInOut | TTTipViewAnimationOptionScaleInOut | TTTipViewAnimationOptionGrowth;
    [tipView setText:text];
    [tipView showInView:view animated:YES animationOptions:options];
}

+ (void)dismissLoading {
    
    TTTipView *tipView = [TTTipView currentTipView];
    // 这里要做类型判断，否则没有执行顺序有问题的时候，可能dismiss错误的view
    // 比如showLoading->showError->dissmissLoading
    if (tipView.tipType == TTTipViewTypeLoading) {
        [TTTipView dismissCurrentTipViewAnimated:YES];
    }
}

+ (void)dismissLoadingDelay:(CFTimeInterval)time {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIUtil dismissLoading];
    });
}

//-------------------------------------------------------------------------------------------------------------------------

+ (void)showError:(NSError *)error {
     [UIUtil showError:error withMessage:nil];
}

/// 错误提示:可选择是否会阻挡用户的后续操作
+ (void)showErrorMessage:(NSError *)error isBlockUser:(BOOL)isBlockUser {
    [UIUtil showError:error withMessage:nil isBlockUser:isBlockUser];
}

/// 错误提示:可选择是否会阻挡用户的后续操作
+ (void)showError:(NSError *)error withMessage:(NSString *)message isBlockUser:(BOOL)isBlockUser {

    NSString *errMessage = [error localizedDescription];
    
    if ([error.domain isEqualToString:@"TT"]) {
        errMessage = error.userInfo[@"info"];
    }
    
    if ([message length] == 0) {
        message = errMessage;
    } else {
        message = [NSString stringWithFormat:@"%@:%@", message, errMessage];
    }
    
    message = [NSString stringWithFormat:@"%@(%ld)", message, (long)[error code]];
    
    [UIUtil showHint:message isBlockUser:isBlockUser];
}

+ (void)showError:(NSError *)error withMessage:(NSString *)message {
    
    NSString *errMessage;
    
    if ([error.domain isEqualToString:@"TT"]) {
        errMessage = error.userInfo[@"info"];
    }
    if (!errMessage) {
        errMessage = [error localizedDescription];
    }
    
    if ([message length] == 0) {
        message = errMessage;
    } else {
        message = [NSString stringWithFormat:@"%@:%@", message, errMessage];
    }
    if (![error.domain isEqualToString:@"TT"]) {
        message = [NSString stringWithFormat:@"%@(%ld)", message, (long)[error code]];
    }
    
    [UIUtil showHint:message];
}

+ (void)showErrorMessage:(NSString *)message
{
    [UIUtil showHint:NSLocalizedString(message,nil)];
}

//-------------------------------------------------------------------------------------------------------------------------

+ (CGSize)calculateTextViewSizeForString:(NSString *)string withFont:(UIFont *)font inSize:(CGSize)size {
    
    textViewForHeightCalculation.attributedText = nil;
    textViewForHeightCalculation.font = font;
    textViewForHeightCalculation.text = string;
    return [textViewForHeightCalculation sizeThatFits:size];
}

+ (CGSize)calculateTextViewSizeForAttributedString:(NSAttributedString *)string inSize:(CGSize)size {
    textViewForHeightCalculation.text = nil;
    textViewForHeightCalculation.attributedText = string;
    return [textViewForHeightCalculation sizeThatFits:size];;
}

+ (CGSize)calculateSizeForAttributedString:(NSAttributedString *)string inSize:(CGSize)size {size.height = 1000000;
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}

#pragma mark - private
+ (NSString *)eachStepDoubleFormatStr:(double)num withAccuracy:(UInt32)accuracy andChoice:(EachStepFormatChoice)choice isPreciseOrNot:(BOOL)isPrecise{
    if (num >= 10000000){
        return [UIUtil getDoubleFormatStr:num withAccuracy:accuracy andChoice:(eachStepStringFormatChoice[choice][2]) isPreciseOrNot:isPrecise];
    }
    else if (num >= 10000){
        return [UIUtil getDoubleFormatStr:num withAccuracy:accuracy andChoice:(eachStepStringFormatChoice[choice][1]) isPreciseOrNot:isPrecise];
    }
    else {
        return [UIUtil getDoubleFormatStr:num withAccuracy:accuracy andChoice:(eachStepStringFormatChoice[choice][0]) isPreciseOrNot:isPrecise];
    }
}

+ (NSString *)getIntFormatStr:(SInt64)num withAccuracy:(UInt32)accuracy andChoice:(StringFormatChoice)choice isPreciseOrNot:(BOOL)isPrecise{
    double doubleNum = (double)num;
    return [UIUtil getDoubleFormatStr:doubleNum withAccuracy:accuracy andChoice:choice isPreciseOrNot:isPrecise];
}

+ (NSString *)getDoubleFormatStr:(double)num withAccuracy:(UInt32)accuracy andChoice:(StringFormatChoice)choice isPreciseOrNot:(BOOL)isPrecise{
    SInt64 boundary = 10000;
    if (choice < 3) {
        boundary = 1000;
    }
    else {
        boundary = 10000;
    }
    return [UIUtil getDoubleFormatStr:num withAccuracy:accuracy upperBoundary:boundary andChoice:choice isPreciseOrNot:isPrecise];
}

+ (NSString *)getIntFormatStr:(SInt64)num withAccuracy:(UInt32)accuracy upperBoundary:(SInt64)boundary andChoice:(StringFormatChoice)choice isPreciseOrNot:(BOOL)isPrecise {
    double doubleNum = (double)num;
    return [UIUtil getDoubleFormatStr:doubleNum withAccuracy:accuracy upperBoundary:boundary andChoice:choice isPreciseOrNot:isPrecise];
}

+ (NSString *)getDoubleFormatStr:(double)num withAccuracy:(UInt32)accuracy upperBoundary:(SInt64)boundary andChoice:(StringFormatChoice)choice isPreciseOrNot:(BOOL)isPrecise {
    num = num > 0 ? num : 0;
    int places = 4;
    SInt64 acBounary = 10000;
    if (choice < 3) {
        acBounary = 1000 <= boundary ? boundary : 1000;
    }
    else {
        acBounary = 10000 <= boundary ? boundary : 10000;
    }
    // 如果数值本身小于upperBoundary (默认boundary是单位对应的数值(1000/10000)),返回的字符串就是数值本身
    if (choice == StringFormatChoice_ChineseK || choice == StringFormatChoice_CapK || choice == StringFormatChoice_lowk) {
        if (num < acBounary){
            return [NSString stringWithFormat:@"%.0f",num];// 返回的字符串就是数值本身
        }
        places = 3;
        num /= 1000;
    }
    else if(choice == StringFormatChoice_ChineseKW || choice == StringFormatChoice_CapKW || choice == StringFormatChoice_lowkw) {
        places = 7;
        num /= 10000000;
    }
    else {
        if (num < acBounary){
            return [NSString stringWithFormat:@"%.0f",num];// 返回的字符串就是数值本身
        }
        places = 4;
        num /= 10000;
    }
    //
    NSMutableString *result = [NSMutableString string];
    // places <= accuracy相当于保留小数点后所有部分.
    int extraLength = (double)places - (double)accuracy <= 0 ? 0 : (double)places - (double)accuracy;
    if (extraLength == 0 || isPrecise) {
        result = [NSMutableString stringWithFormat:numberFormatArr[places],num];
        if (isPrecise && accuracy == 0) {
            result = [[result substringToIndex: result.length - extraLength - 1] mutableCopy];// 多余的小数点.
        }
        else {
            result = [[result substringToIndex: result.length - extraLength] mutableCopy];
        }
    }
    else {
        result = [NSMutableString stringWithFormat:numberFormatArr[accuracy],num];
    }
    NSString *symbol = [stringFormatChoiceArr objectAtIndex:choice] ? : @"W";
    [result appendString:symbol];
    return result;
}

#define gestureMinimumTranslation 20
+ (GesMoveDirection)directionForTranslation:(CGPoint)translation;
{

    // determine if horizontal swipe only if you meet some minimum velocity
    if(fabs(translation.x) > gestureMinimumTranslation)
        {
        BOOL gestureHorizontal = NO;
        if(translation.y ==0.0)
            gestureHorizontal = YES;
        else
            gestureHorizontal = (fabs(translation.x / translation.y) >5.0);
        if(gestureHorizontal)
            {
            if(translation.x >0.0)
                return GesMoveDirectionRight;
            else
                return GesMoveDirectionLeft;
            }
        }
    // determine if vertical swipe only if you meet some minimum velocity
    else if(fabs(translation.y) > gestureMinimumTranslation)
        {
        BOOL gestureVertical = NO;
        if(translation.x ==0.0)
            gestureVertical = YES;
        else
            gestureVertical = (fabs(translation.y / translation.x) >5.0);
        if(gestureVertical)
            {
            if(translation.y >0.0)
                return GesMoveDirectionDown;
            else
                return GesMoveDirectionUp;
            }
        }
    return GesMoveDirectionNone;
}

+ (void)dismissKeyboardIfNeeded {
    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
    UIView *firstResp = [keyWindow performSelector:@selector(firstResponder)];
    [firstResp resignFirstResponder];
}

+ (UIImage*)imageWithUIView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO,0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

@end
