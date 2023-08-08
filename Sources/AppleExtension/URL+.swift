//
//  URL+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/8/8.
//

import Foundation

public extension URL {
    /// Returns a URL constructed by appending the given path to self.
    /// - Parameters:
    ///   - path: The path to add
    func appendingPath(_ path: String) -> URL {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return self.appending(path: path)
        } else {
            return self.appendingPathComponent(path)
        }
    }

    /// Initializes a newly created file URL referencing the local file or directory at path, relative to a base URL.
    ///
    /// If an empty string is used for the path, then the path is assumed to be ".".
    init(fileURLPath path: String) {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            self.init(filePath: path)
        } else {
            self.init(fileURLWithPath: path)
        }
    }

    /// If the URL conforms to RFC 1808 (the most common form of URL), returns the path
    /// component of the URL; otherwise it returns an empty string.
    /// - note: This function will resolve against the base `URL`.
    /// - Parameter percentEncoded: whether the path should be percent encoded,
    ///   defaults to `true`.
    /// - Returns: the path component of the URL.
    func urlPath(percentEncoded: Bool = true) -> String {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return self.path(percentEncoded: percentEncoded)
        } else {
            return self.path
        }
    }
}
