// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation

// MARK: - Duration

// MARK: waitFor(timeout:checkCondition:) async throws

/// Polls the condition every 10 milliseconds until it returns true.
///
/// - Throws: ``TestTimeoutError`` when the timeout is reached before the condition.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public func waitFor(
    timeout: Duration = .testTimeout,
    checkCondition: () -> Bool
) async throws {
    try await waitFor(
        clock: ContinuousClock(),
        timeout: timeout,
        pollingInterval: .pollingInterval,
        checkCondition: checkCondition
    )
}

/// Base internal wait logic for testing.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
func waitFor<Clock>(
    clock: Clock,
    timeout: Clock.Duration,
    pollingInterval: Duration,
    checkCondition: () -> Bool
) async throws where Clock: Swift.Clock {
    let timeout = clock.now.advanced(by: timeout)

    while true {
        guard !checkCondition() else {
            return
        }

        guard clock.now < timeout else {
            throw TestTimeoutError()
        }

        try await Task.sleep(for: pollingInterval)
    }
}

// MARK: waitFor<Value>(expected:timeout:currentValue:) async throws

/// Polls the condition every 10 milliseconds until the values equals the expected value.
///
/// - Throws: ``TestTimeoutError`` when the timeout is reached before the condition.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public func waitFor<Value>(
    expected: Value,
    timeout: Duration = .testTimeout,
    currentValue: @autoclosure () -> Value
) async throws where Value: Equatable {
    try await waitFor(
        clock: ContinuousClock(),
        expected: expected,
        timeout: timeout,
        pollingInterval: .pollingInterval,
        currentValue: currentValue
    )
}

/// Base internal wait logic for testing.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
func waitFor<Clock, Value>(
    clock: Clock,
    expected: Value,
    timeout: Clock.Duration,
    pollingInterval: Duration,
    currentValue: () -> Value
) async throws where Clock: Swift.Clock, Value: Equatable {
    try await waitFor(
        clock: clock,
        timeout: timeout,
        pollingInterval: pollingInterval,
        checkCondition: { currentValue() == expected }
    )
}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Duration {
    fileprivate static let pollingInterval = Duration.milliseconds(10)
}

// MARK: - TimeInterval

// MARK: waitFor(timeoutTimeInterval:checkCondition:) async throws

/// Waits until the timeout, polling the condition every 10 milliseconds.
@available(iOS, deprecated: 16.0, message: "Use `timeout: Duration` based wait instead.")
@available(macOS, deprecated: 13.0, message: "Use `timeout: Duration` based wait instead.")
@available(watchOS, deprecated: 9.0, message: "Use `timeout: Duration` based wait instead.")
@available(tvOS, deprecated: 16.0, message: "Use `timeout: Duration` based wait instead.")
@available(*, message: "Use `timeout: Duration` based wait instead.")
public func waitFor(
    timeoutTimeInterval timeout: TimeInterval,
    checkCondition: () -> Bool
) async throws {
    try await waitFor(
        timeoutTimeInterval: timeout,
        pollingInterval: .pollingInterval,
        checkCondition: checkCondition,
        now: { Date() }
    )
}

/// Base internal wait logic for testing.
func waitFor(
    timeoutTimeInterval timeout: TimeInterval,
    pollingInterval: UInt64,
    checkCondition: () -> Bool,
    now: () -> Date
) async throws {
    let timeout = now().addingTimeInterval(timeout)

    while true {
        guard !checkCondition() else {
            return
        }

        guard now() < timeout else {
            throw TestTimeoutError()
        }

        try await Task.sleep(nanoseconds: pollingInterval)
    }
}

// MARK: waitFor<Value>(expected:timeoutTimeInterval:currentValue:) async throws

/// Polls the condition every 10 milliseconds until the values equals the expected value.
///
/// - Throws: ``TestTimeoutError`` when the timeout is reached before the condition.
@available(iOS, deprecated: 16.0, message: "Use `timeout: Duration` based wait instead.")
@available(macOS, deprecated: 13.0, message: "Use `timeout: Duration` based wait instead.")
@available(watchOS, deprecated: 9.0, message: "Use `timeout: Duration` based wait instead.")
@available(tvOS, deprecated: 16.0, message: "Use `timeout: Duration` based wait instead.")
@available(*, message: "Use `timeout: Duration` based wait instead.")
public func waitFor<Value>(
    expected: Value,
    timeoutTimeInterval timeout: TimeInterval,
    currentValue: @autoclosure () -> Value,
) async throws where Value: Equatable {
    try await waitFor(
        expected: expected,
        timeoutTimeInterval: timeout,
        pollingInterval: .pollingInterval,
        currentValue: currentValue,
        now: { Date() }
    )
}

func waitFor<Value>(
    expected: Value,
    timeoutTimeInterval timeout: TimeInterval,
    pollingInterval: UInt64,
    currentValue: () -> Value,
    now: () -> Date
) async throws where Value: Equatable {
    try await waitFor(
        timeoutTimeInterval: timeout,
        pollingInterval: pollingInterval,
        checkCondition: { currentValue() == expected },
        now: now
    )
}

extension UInt64 {
    fileprivate static let pollingInterval: UInt64 = 10_000_000
}
