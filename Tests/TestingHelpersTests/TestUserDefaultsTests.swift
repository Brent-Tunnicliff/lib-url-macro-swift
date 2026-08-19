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
        try await waitFor(timeoutTimeInterval: .testTimeout) {
            let userDefaults = try? createUserDefaults()
            return userDefaults?.value(forKey: key) == nil
        }
    }
}
