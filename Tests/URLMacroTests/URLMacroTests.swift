import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing

#if canImport(URLMacroModule)
    import URLMacroModule
    private let testMacros: [String: MacroSpec] = ["url": MacroSpec(type: URLMacro.self)]
#else
    private let testMacros: [String: MacroSpec] = [:]
#endif

@Suite(.enabled(if: !testMacros.isEmpty, "Platform does not support Macros"))
struct URLMacroTests {
    #if canImport(FoundationEssentials)
        private let foundation = "FoundationEssentials"
    #elseif canImport(Foundation)
        private let foundation = "Foundation"
    #endif

    @Test(arguments: [
        "www.google.com",
        "https://www.google.com",
        "https://www.google.com/search?q=swift-syntax-macros",
    ])
    func valid(url: String) {
        let input = "#url(\"\(url)\")"
        let expectedResult = "\(foundation).URL(string: \"\(url)\")!"

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            macroSpecs: testMacros,
            failureHandler: Issue.record(failure:)
        )
    }
}
