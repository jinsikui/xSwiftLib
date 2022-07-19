#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Theme)

+ (UIFont *)SFDisplayBold:(CGFloat)size;
+ (UIFont *)SFDisplayBoldItalic:(CGFloat)size;
+ (UIFont *)SFDisplayMedium:(CGFloat)size;
+ (UIFont *)SFDisplayMediumItalic:(CGFloat)size;
+ (UIFont *)SFDisplayRegular:(CGFloat)size;
+ (UIFont *)SFDisplayRegularItalic:(CGFloat)size;
+ (UIFont *)SFDisplaySemibold:(CGFloat)size;

+ (UIFont *)RobotoRegular:(CGFloat)size;
+ (UIFont *)RobotoMedium:(CGFloat)size;
+ (UIFont *)RobotoBold:(CGFloat)size;

+ (UIFont *)HelveticaRegular:(CGFloat)size;
+ (UIFont *)HelveticaMedium:(CGFloat)size;

+ (UIFont *)PingFangSCRegular:(CGFloat)size;
+ (UIFont *)PingFangSCSemibold:(CGFloat)size;
+ (UIFont *)PingFangSCMedium:(CGFloat)size;

// HoeflerText
+ (UIFont *)hoeflerRegular:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
