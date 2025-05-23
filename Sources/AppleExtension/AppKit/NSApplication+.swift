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
    static func terminate(after action: (@Sendable () async -> Void)? = nil) {
        if let action = action {
            Task {
                await action()
                NSApp.terminate(nil)
            }
        } else {
            NSApp.terminate(nil)
        }
    }

    enum TerminateResult: Sendable {
        case normal
        case timeout
    }

    static func terminate(after action: @Sendable @escaping () async -> Void, timeout: TimeInterval, callback: (@Sendable (TerminateResult) async -> Void)? = nil) {
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

public extension NSApplication {
    func activeApp() {
#if swift(>=5.9)
        if #available(macOS 14.0, *) {
            activate()
        } else {
            activate(ignoringOtherApps: true)
        }
#else
        activate(ignoringOtherApps: true)
#endif
    }
}

#endif
