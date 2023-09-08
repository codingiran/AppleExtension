//
//  UserDefaults+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/9/8.
//

import Foundation

public extension UserDefaults {
    func setCodableValue<T>(_ value: T, for key: String) where T: Codable {
        guard let data = try? JSONEncoder().encode(value),
              let json = try? JSONSerialization.jsonObject(with: data)
        else {
            set(nil, forKey: key)
            return
        }
        set(json, forKey: key)
    }

    func getCodableValue<T>(of type: T.Type, for key: String) -> T? where T: Codable {
        guard let json = object(forKey: key),
              let data = try? JSONSerialization.data(withJSONObject: json),
              let value = try? JSONDecoder().decode(T.self, from: data)
        else { return nil }
        return value
    }
}

public extension UserDefaults {
    func sync() { CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication) }
}
