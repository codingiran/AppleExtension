//
//  NEVPNManager+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/8/26.
//

#if canImport(NetworkExtension)

import Foundation
import NetworkExtension

public extension NEVPNManager {
    func save(wait seconds: TimeInterval? = nil) async throws {
        try await saveToPreferences()
        if let seconds {
            try await Task.sleep(seconds: seconds)
        }
    }
}

#endif
