import Foundation
import UIKit

/// 中文字体
class WCWFont: NSObject {
  @objc class func regular(_ size: CGFloat) -> UIFont {
    return UIFont.pingFangSCRegular(size)
  }

  @objc class func medium(_ size: CGFloat) -> UIFont {
    return UIFont.pingFangSCMedium(size)
  }

  @objc class func semibold(_ size: CGFloat) -> UIFont {
    return UIFont.pingFangSCSemibold(size)
  }
}

/// 英文字体
class WCWEnFont: NSObject {
  @objc class func regular(_ size: CGFloat) -> UIFont {
    return UIFont.sfDisplayRegular(size)
  }

  @objc class func medium(_ size: CGFloat) -> UIFont {
    return UIFont.sfDisplayMedium(size)
  }

  @objc class func semibold(_ size: CGFloat) -> UIFont {
    return UIFont.sfDisplaySemibold(size)
  }

  @objc class func bold(_ size: CGFloat) -> UIFont {
    return UIFont.sfDisplayBold(size)
  }
}
