//
//  NETunnelProviderManager+.swift
//  AppleExtension
//
//  Created by CodingIran on 2023/8/26.
//

#if canImport(NetworkExtension)

import Foundation
import NetworkExtension

public extension NETunnelProviderManager {
    convenience init(localizedDescription: String?,
                     isOnDemandEnabled: Bool = false,
                     onDemandRules: [NEOnDemandRule]? = nil,
                     protocolConfiguration: NEVPNProtocol? = nil)
    {
        self.init()
        self.localizedDescription = localizedDescription
        self.isOnDemandEnabled = isOnDemandEnabled
        self.onDemandRules = onDemandRules
        self.protocolConfiguration = protocolConfiguration
    }

    func enaleOnDemandVPN(_ enable: Bool, rules: [NEOnDemandRule]? = .defaultConnectRules, needSave: Bool = false) async throws {
        if isOnDemandEnabled != enable {
            isOnDemandEnabled = enable
        }
        if enable {
            if onDemandRules != rules {
                onDemandRules = rules
            }
        } else {
            if onDemandRules != nil {
                onDemandRules = nil
            }
        }
        guard needSave else { return }
        try await save()
    }
}

#endif
