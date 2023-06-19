//
//  NSAlert+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

#if canImport(AppKit)

import AppKit

public extension NSAlert {
    static func alert(with text: String) {
        let alert = NSAlert()
        alert.messageText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: NSLocalizedString("OK", comment: ""))
        alert.runModal()
    }

    /**
     Workaround to allow using `NSAlert` in a `Task`.

     [FB9857161](https://github.com/feedback-assistant/reports/issues/288)
      https://stackoverflow.com/questions/70358323/nsalert-runmodal-crashed-when-called-from-task-init
     */
    @MainActor
    @discardableResult
    func run() async -> NSApplication.ModalResponse {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async { [self] in
                continuation.resume(returning: runModal())
            }
        }
    }
}

#endif
