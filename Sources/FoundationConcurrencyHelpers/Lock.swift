// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(Darwin)
    public import Foundation
#else
    public import NIOConcurrencyHelpers
#endif

/// Wrapper of NSLock if platform is Darwin based, or NIOLock if not.
public struct Lock: Sendable {
    #if canImport(Darwin)
        @usableFromInline
        let _lock = NSLock()
    #else
        @usableFromInline
        let _lock = NIOLock()
    #endif

    /// Create a new lock.
    @inlinable
    public init() {}

    /// Acquire the lock.
    @inlinable
    public func lock() {
        _lock.lock()
    }

    /// Release the lock.
    @inlinable
    public func unlock() {
        _lock.unlock()
    }

    /// Acquire the lock for the duration of the given block.
    ///
    /// - Parameter body: The block to execute while holding the lock.
    /// - Returns: The value returned by the block.
    @inlinable
    public func withLock<T>(_ body: () throws -> T) rethrows -> T {
        try _lock.withLock(body)
    }
}
