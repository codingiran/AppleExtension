//
//  NSImage+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

#if canImport(AppKit)

import AppKit

public extension NSImage {
    func tint(color: NSColor) -> NSImage {
        let image = copy() as! NSImage
        image.lockFocus()
        color.set()
        let imageRect = NSRect(origin: NSPoint.zero, size: image.size)
        imageRect.fill(using: .sourceIn)
        image.unlockFocus()
        image.isTemplate = false
        return image
    }
}

#endif
