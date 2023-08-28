//
//  NEPacketTunnelNetworkSettings+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/8/26.
//

#if canImport(NetworkExtension)

import NetworkExtension

public extension NEPacketTunnelNetworkSettings {
    typealias Ipv4Config = (addresses: [String], subnetMasks: [String], includedRoutes: [NEIPv4Route]?)
    typealias Ipv6Config = (addresses: [String], networkPrefixLengths: [UInt], includedRoutes: [NEIPv6Route]?)
    typealias DNSConfig = (servers: [String], matchDomains: [String]?)

    convenience init(remoteAddress: String,
                     ipv4Config: Ipv4Config? = nil,
                     ipv6Config: Ipv6Config? = nil,
                     dnsConfig: DNSConfig? = nil,
                     proxySettings: NEProxySettings? = nil,
                     mtu: UInt = 1500)
    {
        self.init(tunnelRemoteAddress: remoteAddress)
        if let ipv4Config {
            let ipv4Settings = NEIPv4Settings(addresses: ipv4Config.addresses, subnetMasks: ipv4Config.subnetMasks)
            if let includedRoutes = ipv4Config.includedRoutes {
                ipv4Settings.includedRoutes = includedRoutes
            }
            self.ipv4Settings = ipv4Settings
        }
        if let ipv6Config {
            let ipv6Settings = NEIPv6Settings(addresses: ipv6Config.addresses, networkPrefixLengths: ipv6Config.networkPrefixLengths.map { NSNumber(value: $0) })
            if let includedRoutes = ipv6Config.includedRoutes {
                ipv6Settings.includedRoutes = includedRoutes
            }
            self.ipv6Settings = ipv6Settings
        }
        if let dnsConfig {
            let dnsSettings = NEDNSSettings(servers: dnsConfig.servers)
            dnsSettings.matchDomains = dnsConfig.matchDomains
            self.dnsSettings = dnsSettings
        }
        self.mtu = NSNumber(value: mtu)
    }
}

public extension Array where Element == NEIPv4Route {
    static var defaultIpv4Routes: [NEIPv4Route] { [NEIPv4Route.default()] }
}

public extension Array where Element == NEIPv6Route {
    static var defaultIpv6Routes: [NEIPv6Route] { [NEIPv6Route.default()] }
}

#endif
