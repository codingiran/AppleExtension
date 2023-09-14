//
//  NSApplication+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

#if canImport(AppKit)

import AppKit
import Foundation

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

    static func terminate(after action: @escaping () async -> Void, timeout: TimeInterval) {
        Task {
            let task = Task.detached(timeout: timeout) {
                await action()
            }
            _ = try await task.value
            Task { @MainActor in
                NSApp.terminate(nil)
            }
        } catch: { _ in
            // timeout
            Task { @MainActor in
                NSApp.terminate(nil)
            }
        }
    }
}

#endif
