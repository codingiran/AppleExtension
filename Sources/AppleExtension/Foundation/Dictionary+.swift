//
//  Dictionary+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

import Foundation

public extension Dictionary {
    func toJSONString(prettyPrint: Bool = false) -> String? {
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: self, options: prettyPrint ? [.prettyPrinted] : []),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return nil
        }
        return jsonString
    }
}
