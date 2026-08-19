// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import CommonMacroHelpers
import Testing
import URLHelpers

#if canImport(FoundationEssentials)
    import FoundationEssentials
    private let skipFoundation = true
    private let skipFoundationEssentials = false
#else
    import Foundation
    private let skipFoundation = false
    private let skipFoundationEssentials = true
#endif

/// Macros only work with literal inputs, so the string input needs to be duplicated across each test.
struct URLMacroTests {
    let expectedResult: URL

    init() throws {
        self.expectedResult = try #require(URL(string: "www.tunnicliff.dev"))
    }

    @Test
    func url() {
        #expect(#url("www.tunnicliff.dev") == expectedResult)
    }

    @Test
    func urlModuleNone() {
        #expect(#url("www.tunnicliff.dev", module: .none) == expectedResult)
    }

    @Test(.disabled(if: skipFoundation))
    func urlModuleFoundation() {
        #if canImport(FoundationEssentials)
            Issue.record("Foundation not imported")
        #else
            #expect(#url("www.tunnicliff.dev", module: .foundation) == expectedResult)
        #endif
    }

    @Test(.disabled(if: skipFoundationEssentials))
    func urlModuleFoundationEssentials() {
        #if canImport(FoundationEssentials)
            #expect(#url("www.tunnicliff.dev", module: .foundationEssentials) == expectedResult)
        #else
            Issue.record("FoundationEssentials not imported")
        #endif
    }
}
