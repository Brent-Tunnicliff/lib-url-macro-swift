// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import ConcurrencyHelpers

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Clock where Self == TestClock {
    /// An instance of ``TestClock`` used for testing.
    public static func test(now: Instant = .zero) -> Self {
        Self(now: now)
    }
}

/// Clock used for testing.
///
/// The now value can be manipulated with to simulate the passing of time.
/// - Warning: Time does not pass automatically, only via manual calls to advance or set the now instance.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class TestClock: Clock, Sendable {
    private let _now: LockedValueBox<Instant>

    /// The current instant value.
    public var now: Instant {
        _now.withLockedValue { $0 }
    }

    /// The minimum resolution between any two calls to now.
    public let minimumResolution: Duration

    /// Create an instance of ``TestClock``.
    public init(now: Instant = .zero) {
        self._now = LockedValueBox(value: now)
        self.minimumResolution = .zero
    }

    /// Yields the task before setting now to the deadline to simulate sleep.
    public func sleep(until deadline: Instant, tolerance: Duration?) async throws {
        await Task.yield()
        set(now: deadline)
    }

    /// Advance the value of `now` by the input duration.
    public func advance(by duration: Duration) {
        _now.withLockedValue {
            $0 = $0.advanced(by: duration)
        }
    }

    /// Overrides the value of `now`.
    public func set(now: Instant) {
        _now.withLockedValue {
            $0 = now
        }
    }
}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TestClock {
    /// A point in time used for ``TestClock``.
    public struct Instant: InstantProtocol, Sendable {
        /// An instant at zero duration.
        public static let zero = Instant(value: .zero)

        /// The duration type used by this clock instant.
        public typealias Duration = Swift.Duration

        /// The duration value of this instant in time.
        public let value: Duration

        /// Create an instance of ``Instant``.
        public init(value: Duration) {
            self.value = value
        }

        /// Compares the two Instants based on the duration.
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.value < rhs.value
        }

        /// Returns a new instant, with the applied duration applied.
        public func advanced(by duration: Duration) -> Self {
            Instant(value: value + duration)
        }

        /// Returns the duration of input instant from this object.
        public func duration(to other: Self) -> Duration {
            other.value - value
        }
    }
}
