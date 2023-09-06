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

    @discardableResult
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

public extension FileHandle {
    var availableString: String {
        let data = availableData
        return String(data: data, encoding: .utf8) ?? "<Non-utf8 data of size\(data.count)>"
    }
}

public extension FileHandle {
    var lastLineString: String? {
        guard let data = try? readLastLine(),
              let str = String(data: data, encoding: .utf8)
        else { return nil }
        return str
    }

    func readLastLine() throws -> Data {
        let endOffset = try seekToFileEnd()
        // Start with an offset to skip the last newline character
        var offset: UInt64 = 2
        var data = Data()
        while true {
            let fileOffset = endOffset - offset
            if fileOffset < 0 {
                // Reached the beginning of the file
                break
            }

            try seekToOffset(fileOffset)
            let byte = try readData(upToCount: 1)

            if byte == Data("\n".utf8) {
                // Found a newline character
                break
            }

            if let byte {
                data.insert(contentsOf: byte, at: 0)
            }
            offset += 1
        }

        try closeFileHandle()
        return data
    }
}

/// https://stackoverflow.com/questions/53978091/using-pipe-in-swift-app-to-redirect-stdout-into-a-textview-only-runs-in-simul
/// https://github.com/imfuxiao/Hamster/blob/0debf92cf4909cb15f4b8deee6bd1f2797974c42/General/Logger/Logger.swift#L55
public struct ConsolePipe {
    public struct StdType: OptionSet {
        public static let input = StdType(rawValue: 1 << 0)
        public static let output = StdType(rawValue: 1 << 1)
        public static let error = StdType(rawValue: 1 << 2)

        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    private var inPipe: Pipe?
    private var outPipe: Pipe?
    private var errPipe: Pipe?

    public init(stdType: StdType = [.input, .output, .error]) {
        if stdType.contains(.input) {
            inPipe = Pipe()
        }
        if stdType.contains(.output) {
            outPipe = Pipe()
        }
        if stdType.contains(.error) {
            errPipe = Pipe()
        }
    }

    public func listen(_ readabilityHandler: @escaping (FileHandle) -> Void) {
        // listen stdin
        if let inPipe {
            setvbuf(stdin, nil, _IONBF, 0)
            dup2(inPipe.fileHandleForWriting.fileDescriptor, STDIN_FILENO)
            inPipe.fileHandleForReading.readabilityHandler = { handle in
                readabilityHandler(handle)
            }
        }

        // listen stdout
        if let outPipe {
            setvbuf(stdout, nil, _IONBF, 0)
            dup2(outPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
            outPipe.fileHandleForReading.readabilityHandler = { handle in
                readabilityHandler(handle)
            }
        }

        // listen stderr
        if let errPipe {
            setvbuf(stderr, nil, _IONBF, 0)
            dup2(errPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
            errPipe.fileHandleForReading.readabilityHandler = { handle in
                readabilityHandler(handle)
            }
        }
    }
}