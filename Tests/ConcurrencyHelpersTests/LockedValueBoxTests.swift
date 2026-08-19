// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import ConcurrencyHelpers

struct LockedValueBoxTests {
    // Test that a large number of concurrent access to locked box does not
    @Test
    func concurrency() async throws {
        let iterations = 1_000
        let startValue = LockedValueBox(value: false)
        let box = LockedValueBox(value: 0)
        await withTaskGroup { group in
            for _ in 0..<iterations {
                group.addTask {
                    while !startValue.withLockedValue({ $0 }) {
                        await Task.yield()
                    }

                    box.withLockedValue {
                        let value = $0
                        // Loop a bunch to simulate work between getting and setting.
                        for _ in 0..<iterations {}
                        $0 = value + 1
                    }
                }
            }

            // Trigger the tests to start interacting with the box.
            startValue.withLockedValue { $0 = true }
            await group.waitForAll()
        }

        #expect(box.withLockedValue { $0 } == iterations)
    }
}
