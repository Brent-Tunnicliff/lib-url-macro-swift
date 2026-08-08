import CommonMacroHelpers
import SwiftSyntaxMacroExpansion
import Testing

#if canImport(MacroModule)
    import MacroModule
    private let testMacros: [String: MacroSpec] = ["url": MacroSpec(type: URLMacro.self)]
#else
    private let testMacros: [String: MacroSpec] = [:]
#endif

@Suite(.enabled(if: !testMacros.isEmpty, "Platform does not support Macros"))
struct URLMacroTests {
    private static let urls = [
        "www.google.com",
        "https://www.google.com",
        "https://www.google.com/search?q=swift-syntax-macros",
    ]

    @Test(arguments: urls)
    func valid(url: String) {
        let input = "#url(\"\(url)\")"
        let expectedResult = "URL(string: \"\(url)\")!"

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            macroSpecs: testMacros
        )
    }

    static var validWithModuleArguments: [(String, Module)] {
        var results: [(String, Module)] = []

        for url in urls {
            for module in Module.allCases {
                results.append((url, module))
            }
        }

        return results
    }

    @Test(arguments: validWithModuleArguments)
    func validWithModule(url: String, module: Module) {
        let input = "#url(\"\(url)\", module: .\(module.rawValue))"
        let expectedUrl = "URL(string: \"\(url)\")!"
        let expectedResult: String
        if let moduleName = module.name {
            expectedResult = "\(moduleName).\(expectedUrl)"
        } else {
            expectedResult = expectedUrl
        }

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            macroSpecs: testMacros
        )
    }

    @Test
    func invalidUrl() {
        let input = "#url(\"\")"
        let expectedResult = input

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            diagnostics: [
                .expected(message: "'' is not a valid URL")
            ],
            macroSpecs: testMacros,
        )
    }

    @Test
    func invalidModuleNotLiteral() {
        let input = "#url(\"www.google.com\", module: value)"
        let expectedResult = input

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            diagnostics: [
                .expected(message: "Module not a literal expression, passing in a runtime value is not supported")
            ],
            macroSpecs: testMacros,
        )
    }

    @Test
    func invalidModule() {
        let input = "#url(\"www.google.com\", module: .value)"
        let expectedResult = input

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            diagnostics: [
                .expected(message: "'value' is not a valid module case")
            ],
            macroSpecs: testMacros,
        )
    }
}
