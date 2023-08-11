//
//  FileHandle+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/8/11.
//

import Foundation
import ObjCExceptionCatcher

public extension FileHandle {
    func readDataToEnd() throws -> Data? {
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            return try readToEnd()
        } else {
            return try ObjCExceptionCatcher.catchException {
                self.readDataToEndOfFile()
            }
        }
    }

    func readData(upToCount count: Int) throws -> Data? {
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            return try read(upToCount: count)
        } else {
            return try ObjCExceptionCatcher.catchException {
                self.readData(ofLength: count)
            }
        }
    }

    func writeData(_ data: Data) throws {
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            try write(contentsOf: data)
        } else {
            try ObjCExceptionCatcher.catchException {
                self.write(data)
            }
        }
    }

    func offsetInFile() throws -> UInt64 {
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            return try offset()
        } else {
            return try ObjCExceptionCatcher.catchException {
                self.offsetInFile
            }
        }
    }

    func seekToFileEnd() throws -> UInt64 {
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            return try seekToEnd()
        } else {
            return try ObjCExceptionCatcher.catchException {
                self.seekToEndOfFile()
            }
        }
    }

    func seekToOffset(_ offset: UInt64) throws {
        if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            return try seek(toOffset: offset)
        } else {
            return try ObjCExceptionCatcher.catchException {
                self.seek(toFileOffset: offset)
            }
        }
    }

    func truncateFile(at offset: UInt64) throws {
        if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            try truncate(atOffset: offset)
        } else {
            try ObjCExceptionCatcher.catchException {
                self.truncateFile(atOffset: offset)
            }
        }
    }

    func sync() throws {
        if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            try synchronize()
        } else {
            try ObjCExceptionCatcher.catchException {
                self.synchronizeFile()
            }
        }
    }

    func closeFileHandle() throws {
        if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            try close()
        } else {
            try ObjCExceptionCatcher.catchException {
                self.closeFile()
            }
        }
    }
}
