//
//  Bundle+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

import Foundation

// MARK: - App Info

public extension Bundle {
    /// App 名称
    var appDisplayName: String {
        guard let name = infoDictionary?["CFBundleDisplayName"] as? String else { return "" }
        return name
    }

    /// App 命名空间
    var namespace: String {
        guard let namespace = infoDictionary?["CFBundleExecutable"] as? String else { return "" }
        return namespace
    }

    /// 获取 app 的 Bundle Identifier
    var appBundleIdentifier: String {
        return bundleIdentifier ?? ""
    }

    /// Bundle 名称
    var bundleName: String {
        return string(forInfoDictionaryKey: "CFBundleName") ?? ""
    }

    /// 获取 Bundle Short 版本号
    var bundleShortVersion: String {
        return string(forInfoDictionaryKey: "CFBundleShortVersionString") ?? ""
    }

    /// 获取 Bundle 版本号
    var bundleVersion: String {
        return string(forInfoDictionaryKey: "CFBundleVersion") ?? ""
    }

    /// 从 Info.plist 中根据 key 取值
    func string(forInfoDictionaryKey key: String) -> String? {
        guard let result = object(forInfoDictionaryKey: key) as? String else { return nil }
        return result
    }
}

// MARK: - App Release Channel

public extension Bundle {
    private static var isDebug: Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }

#if !os(macOS)
    enum AppConfiguration {
        case Debug
        case TestFlight
        case AppStore
    }

    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

    static var appConfiguration: AppConfiguration {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
#endif
}

// MARK: - Check Sandbox

#if os(macOS)

import Security

#endif

public extension Bundle {
    var isSandboxed: Bool {
#if !os(macOS)
        return true
#else
        // https://developer.apple.com/documentation/security
        // https://stackoverflow.com/a/77050105
        let defaultFlags: SecCSFlags = .init(rawValue: 0)
        var staticCode: SecStaticCode?
        if SecStaticCodeCreateWithPath(bundleURL as CFURL, defaultFlags, &staticCode) == errSecSuccess {
            if SecStaticCodeCheckValidityWithErrors(staticCode!, SecCSFlags(rawValue: kSecCSBasicValidateOnly), nil, nil) == errSecSuccess {
                let requirementText = "entitlement[\"com.apple.security.app-sandbox\"] exists" as CFString
                var sandboxRequirement: SecRequirement?
                if SecRequirementCreateWithString(requirementText, defaultFlags, &sandboxRequirement) == errSecSuccess {
                    if SecStaticCodeCheckValidityWithErrors(staticCode!, defaultFlags, sandboxRequirement, nil) == errSecSuccess {
                        return true
                    }
                }
            }
        }
        return false

#endif
    }
}
