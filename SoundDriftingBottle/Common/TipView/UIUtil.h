//
//  UIUtil.h
//  SoundDriftingBottle
//
//  Created by Mac on 2021/2/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, StringFormatChoice) {
    StringFormatChoice_lowk     = 0,
    StringFormatChoice_CapK     = 1,
    StringFormatChoice_ChineseK = 2,
    StringFormatChoice_loww     = 3,
    StringFormatChoice_CapW     = 4,
    StringFormatChoice_ChineseW = 5,
    StringFormatChoice_lowkw    = 6,
    StringFormatChoice_CapKW    = 7,
    StringFormatChoice_ChineseKW= 8,
};

typedef NS_ENUM(NSInteger, EachStepFormatChoice) {
    EachStepFormatChoice_lowk_w_kw        = 0,
    EachStepFormatChoice_CapK_W_KW        = 1,
    EachStepFormatChoice_ChineseK_W_KW    = 2,
};

typedef NS_ENUM(NSInteger, GesMoveDirection) {
    GesMoveDirectionNone,
    GesMoveDirectionUp,
    GesMoveDirectionDown,
    GesMoveDirectionRight,
    GesMoveDirectionLeft
};

@interface UIUtil : NSObject

// 文字提示
+ (void)showHint:(NSString *)text;
/// 文字提示:可选择是否会阻挡用户的后续操作
+ (void)showHint:(NSString *)text isBlockUser:(BOOL)isBlockUser;

// 在指定的view文字显示
+ (void)showHint:(NSString *)text inView:(UIView *)view;


+ (void)showAttributedHint:(NSAttributedString *)text;

+ (void)showAttributedHint:(NSAttributedString *)text inView:(UIView *)view;

// 不带文字菊花
+ (void)showLoading;

// 带文字菊花
+ (void)showLoadingWithText:(NSString *)text;

+ (void)showLoadingWithView:(UIView*)view;

// 指定显示在某个view里，用于不希望遮挡用户navigationbar之类的情况
// 比如在controller里传入self.view，这样出菊花的时候用户还是可以后退
+ (void)showLoadingWithText:(NSString *)text inView:(UIView *)view;

// 消除菊花
+ (void)dismissLoading;

+ (void)dismissLoadingDelay:(CFTimeInterval)time;

//--------------------------------------------------------------------------------------------------------------------------

+ (void)showError:(NSError *)error;
/// 错误提示:可选择是否会阻挡用户的后续操作
+ (void)showErrorMessage:(NSError *)error isBlockUser:(BOOL)isBlockUser;

/// 错误提示:可选择是否会阻挡用户的后续操作
+ (void)showError:(NSError *)error withMessage:(NSString *)message isBlockUser:(BOOL)isBlockUser;

+ (void)showError:(NSError *)error withMessage:(NSString *)message;

+ (void)showErrorMessage:(NSString *)message; //只显示错误信息，不显示错误代码

//--------------------------------------------------------------------------------------------------------------------------

+ (void)showSelectPhotoSheetInController:(UIViewController *)controller withTitle:(NSString *)title completion:(void(^)(UIImage *image))completion;

+ (CGSize)calculateTextViewSizeForString:(NSString *)string withFont:(UIFont *)font inSize:(CGSize)size;

+ (CGSize)calculateTextViewSizeForAttributedString:(NSAttributedString *)string inSize:(CGSize)size;

/**这个是用boundrect 的可以直接异步计算的*/
+ (CGSize)calculateSizeForAttributedString:(NSAttributedString *)string inSize:(CGSize)size;


//--------------------------------------------------------------------------------------------------------------------------

/**
 返回格式化后的数值字符串,举例：choice为EachSteplowk_w_kw, accuracy为1的情况：1000->1.0k, 10000->1.0w, 10000000->1.0kw
 
 @param num 传入的数值
 @param accuracy 精确到小数点后多少位
 @param choice 单位选择
 @param isPrecise 如果选NO, 会进行四舍五入, 如果选YES, 不会进行四舍五入.
 @return 返回格式化后的数值字符串
 */
+ (NSString *)eachStepDoubleFormatStr:(double)num withAccuracy:(UInt32)accuracy andChoice:(EachStepFormatChoice)choice isPreciseOrNot:(BOOL)isPrecise;

/**
 返回格式化后的数值字符串, 超过对应单位数值(1000/10000)即格式化
 
 @param num 输入数值
 @param accuracy 精确到小数点后多少位
 @param choice 单位选择
 @param isPrecise 如果选NO, 会进行四舍五入, 如果选YES, 不会进行四舍五入.
 @return 返回格式化后的数值字符串
 */
+ (NSString *)getIntFormatStr:(SInt64)num withAccuracy:(UInt32)accuracy andChoice:(StringFormatChoice)choice isPreciseOrNot:(BOOL)isPrecise;

/**
 返回格式化后的数值字符串, 超过对应单位数值(1000/10000)即格式化

 @param num 输入数值
 @param accuracy 精确到小数点后多少位
 @param choice 单位选择
 @param isPrecise 如果选NO, 会进行四舍五入, 如果选YES, 不会进行四舍五入.
 @return 返回格式化后的数值字符串
 */
+ (NSString *)getDoubleFormatStr:(double)num withAccuracy:(UInt32)accuracy andChoice:(StringFormatChoice)choice isPreciseOrNot:(BOOL)isPrecise;

/**
 返回格式化后的数值字符串, boundary用于这样的情形: 单位选择了w, 想要在十万以内的数值（不包括十万）, 不用格式化, 就把upperBoundary设置为十万
 
 @param num 输入数值
 @param accuracy 精确到小数点后多少位
 @param boundary 在boundary以上的数值才会格式化,否则直接返回该数值的字符串.(boundary数值若小于单位数值则不会起作用)
 @param choice 单位选择
 @param isPrecise 如果选NO, 会进行四舍五入, 如果选YES, 不会进行四舍五入.
 @return 返回格式化后的数值字符串
 */
+ (NSString *)getIntFormatStr:(SInt64)num withAccuracy:(UInt32)accuracy upperBoundary:(SInt64)boundary andChoice:(StringFormatChoice)choice isPreciseOrNot:(BOOL)isPrecise;

/**
 返回格式化后的数值字符串, boundary用于这样的情形: 单位选择了w, 想要在十万以内的数值（不包括十万）, 不用格式化, 就把upperBoundary设置为十万

 @param num 输入数值
 @param accuracy 精确到小数点后多少位
 @param boundary 在boundary以上的数值才会格式化,否则直接返回该数值的字符串.(boundary数值若小于单位数值则不会起作用)
 @param choice 单位选择
 @param isPrecise 如果选NO, 会进行四舍五入, 如果选YES, 不会进行四舍五入.
 @return 返回格式化后的数值字符串
 */
+ (NSString *)getDoubleFormatStr:(double)num withAccuracy:(UInt32)accuracy upperBoundary:(SInt64)boundary andChoice:(StringFormatChoice)choice isPreciseOrNot:(BOOL)isPrecise;



+ (GesMoveDirection)directionForTranslation:(CGPoint)translation;

+ (void)dismissKeyboardIfNeeded;

+ (UIImage*)imageWithUIView:(UIView*)view;


@end

NS_ASSUME_NONNULL_END
