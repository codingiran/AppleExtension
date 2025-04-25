//
//  AppleExtension.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/8/28.
//

import Foundation

// Enforce minimum Swift version for all platforms and build systems.
#if swift(<5.9)
#error("AppleExtension doesn't support Swift versions below 5.9.")
#endif

/// Current AppleExtension version 2.2.2. Necessary since SPM doesn't use dynamic libraries. Plus this will be more accurate.
let version = "2.2.2"
