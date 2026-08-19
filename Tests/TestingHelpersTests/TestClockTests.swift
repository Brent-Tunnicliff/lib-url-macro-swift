// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing
import TestingHelpers

struct TestClockTests {
    @Test
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func defaultValue() {
        let expectedValue = TestClock.Instant(value: .zero)
        #expect(TestClock.test().now == expectedValue)
    }

    @Test
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func customValue() {
        let expectedValue = TestClock.Instant(value: Duration(secondsComponent: 123, attosecondsComponent: 456))
        #expect(TestClock.test(now: expectedValue).now == expectedValue)
    }

    @Test
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func sleepUntilSetsDeadlineAsNow() async throws {
        let initialInstant = TestClock.Instant(value: .zero)
        let deadline = initialInstant.advanced(by: .seconds(1))

        let clock = TestClock.test(now: initialInstant)
        try await clock.sleep(until: deadline, tolerance: nil)
        #expect(clock.now == deadline)
    }

    @Test
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func sleepForSetsDeadlineAsNow() async throws {
        let initialInstant = TestClock.Instant(value: .zero)
        let sleepFor = Duration.seconds(2)
        let expectedValue = initialInstant.advanced(by: sleepFor)

        let clock = TestClock.test(now: initialInstant)
        try await clock.sleep(for: sleepFor)
        #expect(clock.now == expectedValue)
    }

    @Test
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func advanceByDuration() {
        let initialInstant = TestClock.Instant(value: .zero)
        let advanceByValue = Duration.seconds(3)
        let expectedValue = initialInstant.advanced(by: advanceByValue)

        let clock = TestClock.test(now: initialInstant)
        clock.advance(by: advanceByValue)

        #expect(clock.now == expectedValue)
    }

    @Test
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func setNow() {
        let expectedValue = TestClock.Instant(value: Duration(secondsComponent: 123, attosecondsComponent: 456))
        let clock = TestClock.test()
        clock.set(now: expectedValue)

        #expect(clock.now == expectedValue)
    }
}
