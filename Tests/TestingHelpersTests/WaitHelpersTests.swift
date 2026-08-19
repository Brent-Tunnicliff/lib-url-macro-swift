// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import TestingHelpers

struct WaitHelpersTests {
    private let timeoutSeconds = 10
    private let timeoutTimeInterval: TimeInterval = 10

    // MARK: - waitFor(timeoutTimeInterval:pollingInterval:checkCondition:now:)

    @Test
    func waitForConditionWithTimeIntervalSuccess() async throws {
        let startDate = Date()
        var counter = 0
        var values = [false, false, false, true]

        try await waitFor(
            timeoutTimeInterval: timeoutTimeInterval,
            pollingInterval: .zero,
            checkCondition: { values.removeFirst() },
            now: {
                counter += 1
                return startDate.addingTimeInterval(TimeInterval(counter))
            }
        )

        // Using how often we called `now` as a rough validation that we were actually looping.
        #expect(counter == 4)
    }

    @Test
    func waitForConditionWithTimeIntervalFailure() async throws {
        let startDate = Date()
        var counter = 0

        await #expect(throws: TestTimeoutError.self) {
            try await waitFor(
                timeoutTimeInterval: timeoutTimeInterval,
                pollingInterval: .zero,
                checkCondition: { false },
                now: {
                    counter += 1
                    return startDate.addingTimeInterval(TimeInterval(counter))
                }
            )
        }

        #expect(counter == 11)
    }

    // MARK: - waitFor(expected:timeoutTimeInterval:pollingInterval:currentValue:now:)

    @Test
    func waitForValueWithTimeIntervalSuccess() async throws {
        let startDate = Date()
        var counter = 0
        let expected = "hello :)"
        let other = "bye :("
        var values = [other, other, other, other, expected]

        try await waitFor(
            expected: expected,
            timeoutTimeInterval: timeoutTimeInterval,
            pollingInterval: .zero,
            currentValue: { values.removeFirst() },
            now: {
                counter += 1
                return startDate.addingTimeInterval(TimeInterval(counter))
            }
        )

        // Using how often we called `now` as a rough validation that we were actually looping.
        #expect(counter == 5)
    }

    @Test
    func waitForValueWithTimeIntervalFailure() async throws {
        let startDate = Date()
        var counter = 0

        await #expect(throws: TestTimeoutError.self) {
            try await waitFor(
                expected: "hello :)",
                timeoutTimeInterval: timeoutTimeInterval,
                pollingInterval: .zero,
                currentValue: { "bye :(" },
                now: {
                    counter += 1
                    return startDate.addingTimeInterval(TimeInterval(counter))
                }
            )
        }

        #expect(counter == 11)
    }

    // MARK: - waitFor(clock:timeout:pollingInterval:checkCondition:)

    @Test
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func waitForConditionWithDurationSuccess() async throws {
        let clock = TestClock()
        var counter = 0
        var values = [false, false, false, true]

        try await waitFor(
            clock: clock,
            timeout: .seconds(timeoutSeconds),
            pollingInterval: .zero,
            checkCondition: {
                counter += 1
                clock.advance(by: .seconds(1))
                return values.removeFirst()
            }
        )

        // Using how often we called `now` as a rough validation that we were actually looping.
        #expect(counter == 4)
    }

    @Test
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func waitForConditionWithDurationFailure() async throws {
        let clock = TestClock()
        var counter = 0

        await #expect(throws: TestTimeoutError.self) {
            try await waitFor(
                clock: clock,
                timeout: .seconds(timeoutSeconds),
                pollingInterval: .zero,
                checkCondition: {
                    counter += 1
                    clock.advance(by: .seconds(1))
                    return false
                }
            )
        }

        #expect(counter == 10)
    }

    // MARK: - waitFor(clock:expected:timeout:pollingInterval:currentValue:)

    @Test
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func waitForValueWithDurationSuccess() async throws {
        let clock = TestClock()
        var counter = 0
        let expected = 1.4
        var values = [1.0, 1.1, 1.2, 1.3, 1.4]

        try await waitFor(
            clock: clock,
            expected: expected,
            timeout: .seconds(timeoutSeconds),
            pollingInterval: .zero,
            currentValue: {
                counter += 1
                clock.advance(by: .seconds(1))
                return values.removeFirst()
            }
        )

        // Using how often we called `now` as a rough validation that we were actually looping.
        #expect(counter == 5)
    }

    @Test
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func waitForValueWithDurationFailure() async throws {
        let clock = TestClock()
        let expected = try #require(UUID(uuidString: "cd9fefe9-3e06-43ce-956c-2072943dd4e4"))
        let valueReturned = try #require(UUID(uuidString: "01a00e7d-1ec9-77c8-a719-18bbd1cff1a5"))
        var counter = 0

        await #expect(throws: TestTimeoutError.self) {
            try await waitFor(
                clock: clock,
                expected: expected,
                timeout: .seconds(timeoutSeconds),
                pollingInterval: .zero,
                currentValue: {
                    counter += 1
                    clock.advance(by: .seconds(1))
                    return valueReturned
                }
            )
        }

        #expect(counter == 10)
    }
}
