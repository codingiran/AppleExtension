//
//  FileManager+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/8/9.
//

import Foundation

public extension FileManager {
    func fileExists(at url: URL) -> Bool {
        let path = url.urlPath(percentEncoded: false)
        return self.fileExists(atPath: path)
    }

    func fileExists(at url: URL, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        let path = url.urlPath(percentEncoded: false)
        return self.fileExists(atPath: path, isDirectory: isDirectory)
    }

    func createFile(at url: URL, contents data: Data?, attributes attr: [FileAttributeKey: Any]? = nil) -> Bool {
        self.createFile(atPath: url.urlPath(percentEncoded: false), contents: data, attributes: attr)
    }

    func contents(at url: URL) -> Data? {
        self.contents(atPath: url.urlPath(percentEncoded: false))
    }

    func isReadableFile(at url: URL) -> Bool {
        self.isReadableFile(atPath: url.urlPath(percentEncoded: false))
    }

    func isWritableFile(at url: URL) -> Bool {
        self.isWritableFile(atPath: url.urlPath(percentEncoded: false))
    }

    func isExecutableFile(at url: URL) -> Bool {
        self.isExecutableFile(atPath: url.urlPath(percentEncoded: false))
    }

    func isDeletableFile(at url: URL) -> Bool {
        self.isDeletableFile(atPath: url.urlPath(percentEncoded: false))
    }

    var applicationSupportDirectory: URL? {
        urls(for: .applicationSupportDirectory, in: .userDomainMask).first
    }

    var cachesDirectory: URL? {
        urls(for: .cachesDirectory, in: .userDomainMask).first
    }

    var libraryDirectory: URL? {
        urls(for: .libraryDirectory, in: .userDomainMask).first
    }

    var documentDirectory: URL? {
        urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
