#import "UIFont+Theme.h"

@implementation UIFont (Theme)

+ (UIFont *)SFDisplaySemibold:(CGFloat)size {
  return [UIFont fontWithName:@"SFProDisplay-Semibold" size:size];
}

+ (UIFont *)SFDisplayRegular:(CGFloat)size {
  return [UIFont fontWithName:@"SFProDisplay-Regular" size:size];
}

+ (UIFont *)SFDisplayRegularItalic:(CGFloat)size {
  return [UIFont fontWithName:@"SFProDisplay-RegularItalic" size:size];
}

+ (UIFont *)SFDisplayMedium:(CGFloat)size {
  return [UIFont fontWithName:@"SFProDisplay-Medium" size:size];
}

+ (UIFont *)SFDisplayMediumItalic:(CGFloat)size {
  return [UIFont fontWithName:@"SFProDisplay-MediumItalic" size:size];
}

+ (UIFont *)SFDisplayBold:(CGFloat)size {
  return [UIFont fontWithName:@"SFProDisplay-Bold" size:size];
}

+ (UIFont *)SFDisplayBoldItalic:(CGFloat)size {
  return [UIFont fontWithName:@"SFProDisplay-BoldItalic" size:size];
}

+ (UIFont *)RobotoRegular:(CGFloat)size {
  return [UIFont fontWithName:@"Roboto-Regular" size:size];
}

+ (UIFont *)RobotoMedium:(CGFloat)size {
  return [UIFont fontWithName:@"Roboto-Medium" size:size];
}

+ (UIFont *)RobotoBold:(CGFloat)size {
  return [UIFont fontWithName:@"Roboto-Bold" size:size];
}

// Helvetica: [
//            Helvetica-Oblique,
//            Helvetica-BoldOblique,
//            Helvetica,
//            Helvetica-Light,
//            Helvetica-Bold,
//            Helvetica-LightOblique
//            ]

+ (UIFont *)HelveticaRegular:(CGFloat)size {
  return [UIFont fontWithName:@"Helvetica" size:size];
}

// Helvetica Neue: [
//                 HelveticaNeue-UltraLightItalic,
//                 HelveticaNeue-Medium,
//                 HelveticaNeue-MediumItalic,
//                 HelveticaNeue-UltraLight,
//                 HelveticaNeue-Italic,
//                 HelveticaNeue-Light,
//                 HelveticaNeue-ThinItalic,
//                 HelveticaNeue-LightItalic,
//                 HelveticaNeue-Bold,
//                 HelveticaNeue-Thin,
//                 HelveticaNeue-CondensedBlack,
//                 HelveticaNeue,
//                 HelveticaNeue-CondensedBold,
//                 HelveticaNeue-BoldItalic
//                 ]
+ (UIFont *)HelveticaMedium:(CGFloat)size {
  return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

// PingFangSC-Medium,
// PingFangSC-Semibold,
// PingFangSC-Light,
// PingFangSC-Ultralight,
// PingFangSC-Regular,
// PingFangSC-Thin

+ (UIFont *)PingFangSCRegular:(CGFloat)size {
  return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *)PingFangSCSemibold:(CGFloat)size {
  return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

+ (UIFont *)PingFangSCMedium:(CGFloat)size {
  return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}

// HoeflerText
+ (UIFont *)hoeflerRegular:(CGFloat)size {
  return [UIFont fontWithName:@"HoeflerText-Regular" size:size];
}

@end
