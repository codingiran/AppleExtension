//
//  DateFormatter+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

import Foundation

public extension DateFormatter {
    convenience init(format: String) {
        self.init()
        dateFormat = format
    }
}
