//
//  NSApplication+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

#if canImport(AppKit)

import AppKit

public extension NSApplication {
    static func terminate(after action: (() async -> Void)? = nil) {
        if let action = action {
            Task {
                await action()
                NSApp.terminate(nil)
            }
        } else {
            NSApp.terminate(nil)
        }
    }
}

#endif
