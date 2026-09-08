// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

#if canImport(FoundationHelpersMacroModule)
    @testable import FoundationHelpersMacroModule
    private let canTestMacros = true
#else
    private let canTestMacros = true
#endif

@Suite("Collection+safeTests")
struct CollectionSafeTests {
    let collection = 0..<9

    @Test(.disabled(if: !canTestMacros))
    func subscriptSafeIndexInt() {
        #if canImport(FoundationHelpersMacroModule)
            #expect(collection[safe: -1] == nil)

            for index in 0..<9 {
                #expect(collection[safe: index] != nil)
            }

            #expect(collection[safe: 9] == nil)
        #endif
    }
}
