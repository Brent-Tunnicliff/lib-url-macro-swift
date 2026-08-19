// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Provides locked access to `Value`.
public final class LockedValueBox<Value> {
    @usableFromInline
    var _unsafeValue: Value

    @usableFromInline
    let lock = Lock()

    /// Initialize the `Value`.
    @inlinable
    public init(value: Value) {
        self._unsafeValue = value
    }

    /// Access the `Value`, allowing mutation of it.
    @inlinable
    public func withLockedValue<T>(_ mutate: (inout Value) throws -> T) rethrows -> T {
        try lock.withLock {
            try mutate(&_unsafeValue)
        }
    }
}

extension LockedValueBox: @unchecked Sendable where Value: Sendable {}
