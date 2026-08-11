// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing
@testable import MacroModule
@testable import SwiftSyntax

@Suite("Collection+safeTests")
struct CollectionSafeTests {
    let collection = 0..<9

    @Test
    func subscriptSafeIndexInt() {
        #expect(collection[safe: -1] == nil)

        for index in 0..<9 {
            #expect(collection[safe: index] != nil)
        }

        #expect(collection[safe: 9] == nil)
    }
}
