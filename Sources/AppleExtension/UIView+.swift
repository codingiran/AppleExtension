//
//  UIView+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

#if canImport(UIKit)

import UIKit

public extension UIView {
    /// 是否可见
    var visible: Bool {
        if self.isHidden || self.alpha <= 0.01 {
            return false
        }
        if self.window != nil {
            return true
        }
        if let window = self as? UIWindow {
            if #available(iOS 13.0, *) {
                return window.windowScene != nil
            } else {
                return true
            }
        }
        return true
    }
}

#endif
