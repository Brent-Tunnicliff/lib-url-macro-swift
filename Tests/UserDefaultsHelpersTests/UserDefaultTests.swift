// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
import TestingHelpers
import UserDefaultsHelpers

extension Trait where Self == ConditionTrait {
    static var disabledIfCannotImportSwiftUI: Self {
        .disabled(if: cannotImportSwiftUI)
    }

    private static var cannotImportSwiftUI: Bool {
        #if canImport(SwiftUI)
            false
        #else
            true
        #endif
    }
}

@MainActor
@Suite(.disabledIfCannotImportSwiftUI)
struct UserDefaultTests {
    @Test
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    func settingValueIsStoredInUserDefaults() throws {
        #if canImport(SwiftUI)
            let harness = try TestHarness()
            let newValue = UUID().uuidString
            harness.value = newValue
            #expect(harness.userDefaults.valueForTesting == newValue)
        #else
            Issue.record("Cannot import SwiftUI")
        #endif
    }

    @Test
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    func gettingValueReturnsUserDefaultsValue() async throws {
        #if canImport(SwiftUI)
            let harness = try TestHarness()
            let newValue = UUID().uuidString
            harness.userDefaults.valueForTesting = newValue
            try await waitFor(expected: newValue, currentValue: harness.value)
        #else
            Issue.record("Cannot import SwiftUI")
        #endif
    }

    @Test
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    func observingValueGetsTriggeredOnNewValue() async throws {
        #if canImport(SwiftUI)
            let harness = try TestHarness()
            try await performObservationTest(harness: harness) {
                harness.value = UUID().uuidString
            }
        #else
            Issue.record("Cannot import SwiftUI")
        #endif
    }

    @Test
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    func observingValueGetsTriggeredOnUserDefaultValueChange() async throws {
        #if canImport(SwiftUI)
            let harness = try TestHarness()
            try await performObservationTest(harness: harness) {
                harness.userDefaults.valueForTesting = UUID().uuidString
            }
        #else
            Issue.record("Cannot import SwiftUI")
        #endif
    }
}

// MARK: - Helpers

#if canImport(SwiftUI)
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    extension UserDefaultTests {
        @MainActor
        fileprivate final class TestHarness {
            let userDefaults: UserDefaults

            @UserDefault
            var value: String?

            init() throws {
                self.userDefaults = try .forTesting()
                self._value = UserDefault(\.valueForTesting, userDefaults: userDefaults)
            }
        }

        fileprivate func performObservationTest(harness: TestHarness, _ updateAction: () -> Void) async throws {
            var iterator = AsyncThrowingStream { continuation in
                withObservationTracking {
                    _ = harness.value
                } onChange: {
                    continuation.yield()
                    continuation.finish()
                }

                Task {
                    try await Task.sleep(for: .seconds(1))
                    continuation.finish(throwing: TestTimeoutError())
                }

                updateAction()
            }.makeAsyncIterator()

            // As long as this completes and does not throw,
            // then it is considered a pass.
            _ = try await iterator.next()
        }
    }

    extension UserDefaults {
        @objc
        fileprivate dynamic var valueForTesting: String? {
            get {
                string(forKey: "string")
            }
            set {
                setValue(newValue, forKey: "string")
            }
        }
    }

#endif
