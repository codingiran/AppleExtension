//
//  Task+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

import Foundation

#if swift(>=5.5)
#if canImport(_Concurrency)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension Task where Failure == Error {
    static func detached(priority: TaskPriority? = nil, timeout: TimeInterval, operation: @escaping @Sendable () async throws -> Success) -> Task<Success, Failure> {
        return Task.detached(priority: priority, operation: {
            try await Task.run(operation: operation, withTimeout: timeout)
        })
    }

    init(priority: TaskPriority? = nil, timeout: TimeInterval, operation: @escaping @Sendable () async throws -> Success) {
        self.init(priority: priority) {
            try await Task.run(operation: operation, withTimeout: timeout)
        }
    }

    private static func run(operation: @escaping @Sendable () async throws -> Success, withTimeout timeout: TimeInterval) async throws -> Success {
        return try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<Success, Error>) in
            let timeoutActor = TimeoutActor()

            Task<Void, Never> {
                do {
                    let operationResult = try await operation()
                    if await timeoutActor.markCompleted() {
                        continuation.resume(returning: operationResult)
                    }
                }
                catch {
                    if await timeoutActor.markCompleted() {
                        continuation.resume(throwing: error)
                    }
                }
            }

            Task<Void, Never> {
                do {
                    try await _Concurrency.Task.sleep(nanoseconds: UInt64(timeout) * 1_000_000_000)
                    if await timeoutActor.markCompleted() {
                        continuation.resume(throwing: TaskTimeoutError())
                    }
                }
                catch {
                    if await timeoutActor.markCompleted() {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}

public struct TaskTimeoutError: LocalizedError {
    public var errorDescription: String? = "Task timed out before completion"
}

private actor TimeoutActor {
    private var isCompleted = false

    func markCompleted() -> Bool {
        if isCompleted {
            return false
        }

        isCompleted = true
        return true
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension Task where Failure == Never, Success == Void {
    @discardableResult
    init(priority: TaskPriority? = nil, operation: @escaping () async throws -> Void, catch: @escaping (Error) -> Void) {
        self.init(priority: priority) {
            do {
                _ = try await operation()
            }
            catch {
                `catch`(error)
            }
        }
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: TimeInterval) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

#endif
#endif
