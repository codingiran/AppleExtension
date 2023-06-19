//
//  UIViewController+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

#if canImport(UIKit)

import UIKit

public extension UIViewController {
    /// 获取当前 controller 里的最高层可见 viewController（可见的意思是还会判断self.view.window是否存在）
    func visibleViewController() -> UIViewController? {
        if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController()
        }
        if let nav = self as? UINavigationController, let visibleVc = nav.visibleViewController {
            return visibleVc.visibleViewController()
        }
        if let tab = self as? UITabBarController, let selectedVc = tab.selectedViewController {
            return selectedVc.visibleViewController()
        }
        if self.isViewLoadedAndVisible {
            return self
        }
        return nil
    }

    var isViewLoadedAndVisible: Bool {
        return self.isViewLoaded && self.view.visible
    }
}

#endif
