//
//  NEVPNConnection+.swift
//  AppleExtension
//
//  Created by CodingIran on 2023/8/26.
//

#if canImport(NetworkExtension)
#if canImport(AppleExtensionObjC)

import AppleExtensionObjC
import Foundation
import NetworkExtension

public extension NEVPNConnection {
    func stopVPNTunnelAsync() async {
        await withCheckedContinuation { cont in
            self.stopVPN {
                cont.resume()
            }
        }
    }
}

#endif
#endif
