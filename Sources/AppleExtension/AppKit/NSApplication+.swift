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

    enum TerminateResult {
        case normal
        case timeout
    }

    static func terminate(after action: @escaping () async -> Void, timeout: TimeInterval, callback: ((TerminateResult) async -> Void)? = nil) {
        Task {
            let task = Task.detached(timeout: timeout) {
                await action()
            }
            _ = try await task.value
            await callback?(.normal)
            Task { @MainActor in
                terminate()
            }
        } catch: { _ in
            // timeout
            await callback?(.timeout)
            Task { @MainActor in
                terminate()
            }
        }
    }
}

#endif
