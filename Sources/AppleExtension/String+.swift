//
//  String+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

import Foundation

public extension String {
    var JSONObject: Any? {
        guard let data = self.data(using: .utf8) else { return nil }
        guard let object = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else { return nil }
        return object
    }

    var JSONDictionary: [String: Any]? {
        guard let dictionary = JSONObject as? [String: Any] else { return nil }
        return dictionary
    }

    var JSONArray: [Any]? {
        guard let array = JSONObject as? [Any] else { return nil }
        return array
    }
}

public extension String {
    func isValidIPv4() -> Bool {
        let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        let regex = try! NSRegularExpression(pattern: validIpAddressRegex, options: [])
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: count))
        guard !matches.isEmpty else { return false }
        return true
    }
}

public extension String {
    var length: Int {
        return self.count
    }

    var firstChar: Character? {
        return self.first
    }

    var lastChar: Character? {
        return self.last
    }

    /// cross-Swift-compatible index
    func find(_ char: Character) -> Index? {
        return self.firstIndex(of: char)
    }
}
