//
//  NSTextField+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

#if canImport(AppKit)

import AppKit

public class NSLabel: NSTextField {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        didInitialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInitialize()
    }

    public func didInitialize() {
        isBezeled = false
        drawsBackground = false
        isEditable = false
        isSelectable = false
    }
}

#endif
