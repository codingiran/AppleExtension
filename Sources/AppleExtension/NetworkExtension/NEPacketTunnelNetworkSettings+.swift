//
//  NEPacketTunnelNetworkSettings+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/8/26.
//

#if canImport(NetworkExtension)

import NetworkExtension

public extension NEPacketTunnelNetworkSettings {
    struct Ipv4Config {
        public var addresses: [String]
        public var subnetMasks: [String]
        public var includedRoutes: [NEIPv4Route]?
        public init(addresses: [String], subnetMasks: [String], includedRoutes: [NEIPv4Route]? = nil) {
            self.addresses = addresses
            self.subnetMasks = subnetMasks
            self.includedRoutes = includedRoutes
        }
    }

    struct Ipv6Config {
        public var addresses: [String]
        public var networkPrefixLengths: [UInt]
        public var includedRoutes: [NEIPv6Route]?
        public init(addresses: [String], networkPrefixLengths: [UInt], includedRoutes: [NEIPv6Route]? = nil) {
            self.addresses = addresses
            self.networkPrefixLengths = networkPrefixLengths
            self.includedRoutes = includedRoutes
        }
    }

    struct DNSConfig {
        public var servers: [String]
        public var matchDomains: [String]?
        public init(servers: [String], matchDomains: [String]? = nil) {
            self.servers = servers
            self.matchDomains = matchDomains
        }
    }

    struct ProxyConfig {
        public var httpServerAddress: String?
        public var httpServerPort: Int?
        public var httpsServerAddress: String?
        public var httpsServerPort: Int?
        public var excludeSimpleHostnames: Bool?
        public var exceptionList: [String]?
        public var matchDomains: [String]?

        public init(httpServerAddress: String?,
                    httpServerPort: Int?,
                    httpsServerAddress: String?,
                    httpsServerPort: Int?)
        {
            self.httpServerAddress = httpServerAddress
            self.httpServerPort = httpServerPort
            self.httpsServerAddress = httpsServerAddress
            self.httpsServerPort = httpsServerPort
        }

        public mutating func httpServerAddress(_ address: String) -> Self {
            self.httpServerAddress = address
            return self
        }

        public mutating func httpServerPort(_ port: Int) -> Self {
            self.httpServerPort = port
            return self
        }

        public mutating func httpsServerAddress(_ address: String) -> Self {
            self.httpsServerAddress = address
            return self
        }

        public mutating func httpsServerPort(_ port: Int) -> Self {
            self.httpsServerPort = port
            return self
        }

        mutating func excludeSimpleHostnames(_ exclude: Bool) -> Self {
            self.excludeSimpleHostnames = exclude
            return self
        }

        public mutating func exceptionList(_ list: [String]?) -> Self {
            self.exceptionList = list
            return self
        }

        public mutating func matchDomains(_ domains: [String]?) -> Self {
            self.matchDomains = domains
            return self
        }
    }

    convenience init(remoteAddress: String,
                     ipv4Config: Ipv4Config? = nil,
                     ipv6Config: Ipv6Config? = nil,
                     dnsConfig: DNSConfig? = nil,
                     proxyConfig: ProxyConfig? = nil,
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
        if let proxySettings {
            self.proxySettings = proxySettings
        }
        if let proxyConfig {
            let proxySettings = NEProxySettings()
            if let httpServerAddress = proxyConfig.httpServerAddress,
               let httpServerPort = proxyConfig.httpServerPort
            {
                proxySettings.httpEnabled = true
                proxySettings.httpServer = NEProxyServer(address: httpServerAddress, port: httpServerPort)
            }
            if let httpsServerAddress = proxyConfig.httpsServerAddress,
               let httpsServerPort = proxyConfig.httpsServerPort
            {
                proxySettings.httpsEnabled = true
                proxySettings.httpsServer = NEProxyServer(address: httpsServerAddress, port: httpsServerPort)
            }
            if let excludeSimpleHostnames = proxyConfig.excludeSimpleHostnames {
                proxySettings.excludeSimpleHostnames = excludeSimpleHostnames
            }
            if let exceptionList = proxyConfig.exceptionList {
                proxySettings.exceptionList = exceptionList
            }
            if let matchDomains = proxyConfig.matchDomains {
                proxySettings.matchDomains = matchDomains
            }
            self.proxySettings = proxySettings
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
