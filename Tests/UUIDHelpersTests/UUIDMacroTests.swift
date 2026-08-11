// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import CommonMacroHelpers
import Testing
import UUIDHelpers

#if canImport(FoundationEssentials)
    import FoundationEssentials
    private let skipFoundation = true
    private let skipFoundationEssentials = false
#else
    import Foundation
    private let skipFoundation = false
    private let skipFoundationEssentials = true
#endif

struct UUIDMacroTests {
    let expectedResult = UUID(
        uuid: (0x44, 0xb6, 0x59, 0x15, 0xae, 0x88, 0x4a, 0x01, 0xb3, 0xe7, 0x97, 0x6e, 0x98, 0xa8, 0x0d, 0x2d)
    )

    @Test
    func uuid() {
        #expect(#uuid("44b65915-ae88-4a01-b3e7-976e98a80d2d") == expectedResult)
    }

    @Test
    func uuidModuleNone() {
        #expect(#uuid("44B65915-AE88-4A01-B3E7-976E98A80D2D", module: .none) == expectedResult)
    }

    @Test(.disabled(if: skipFoundation))
    func uuidModuleFoundation() {
        #if canImport(FoundationEssentials)
            Issue.record("Foundation not imported")
        #else
            #expect(#uuid("44b65915-ae88-4a01-b3e7-976e98a80d2d", module: .foundation) == expectedResult)
        #endif
    }

    @Test(.disabled(if: skipFoundationEssentials))
    func uuidModuleFoundationEssentials() {
        #if canImport(FoundationEssentials)
            #expect(#uuid("44b65915-ae88-4a01-b3e7-976e98a80d2d", module: .foundationEssentials) == expectedResult)
        #else
            Issue.record("FoundationEssentials not imported")
        #endif
    }
}
