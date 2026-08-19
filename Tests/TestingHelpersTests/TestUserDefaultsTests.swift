// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import TestingHelpers

struct TestUserDefaultsTests {
    @Test
    func forTestingDoesNotThrow() throws {
        let _: UserDefaults = try .forTesting()
    }

    @Test
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func dataDeletedOnDeinit() async throws {
        let suiteName = "dataDeletedOnDeinit_\(UUID().uuidString)"
        let createUserDefaults = {
            try #require(TestUserDefaults(suiteName: suiteName))
        }

        var userDefaults: UserDefaults? = try createUserDefaults()
        let key = "EXAMPLE_KEY"
        userDefaults?.set(true, forKey: key)
        userDefaults?.synchronize()
        userDefaults = nil

        // Create it again and assume it cleared the data on deinit.
        try await waitFor {
            guard let userDefaults = try? createUserDefaults() else {
                return false
            }

            return userDefaults.object(forKey: key) == nil
        }
    }
}
