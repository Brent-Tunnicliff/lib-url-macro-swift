import CommonMacroHelpers
import SwiftSyntaxMacroExpansion
import Testing

#if canImport(MacroModule)
    import MacroModule
    private let testMacros: [String: MacroSpec] = ["uuid": MacroSpec(type: UUIDMacro.self)]
#else
    private let testMacros: [String: MacroSpec] = [:]
#endif

@Suite(.enabled(if: !testMacros.isEmpty, "Platform does not support Macros"))
struct UUIDMacroTests {
    private static let validValue = "019ff082-5cfb-7219-a1eb-f27c2cc224d1"
    private static let uuids = [
        "00000000-0000-0000-0000-000000000000",
        "8d336825-4b48-4104-b30e-76949888089d",
        "8D336825-4B48-4104-B30E-76949888089D",
        "ffffffff-ffff-ffff-ffff-ffffffffffff",
        validValue,
    ]

    @Test(arguments: uuids)
    func valid(uuid: String) {
        let input = "#uuid(\"\(uuid)\")"
        let expectedResult = "UUID(uuidString: \"\(uuid)\")!"

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            macroSpecs: testMacros
        )
    }

    static var validWithModuleArguments: [(String, Module)] {
        var results: [(String, Module)] = []

        for uuid in uuids {
            for module in Module.allCases {
                results.append((uuid, module))
            }
        }

        return results
    }

    @Test(arguments: validWithModuleArguments)
    func validWithModule(uuid: String, module: Module) {
        let input = "#uuid(\"\(uuid)\", module: .\(module.rawValue))"
        let expectedUrl = "UUID(uuidString: \"\(uuid)\")!"
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

    @Test(
        arguments: [
            "",
            "1",
            "hello there :)",
            // Valid UUID length and digits without the '-'.
            "00000000000000000000000000000000",
            // UUID contains an invalid character.
            "00000000-0000-0000-0000-00000000000Z",
        ]
    )
    func invalid(value: String) {
        let input = "#uuid(\"\(value)\")"
        let expectedResult = input

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            diagnostics: [
                .expected(message: "'\(value)' is not a valid UUID.")
            ],
            macroSpecs: testMacros,
        )
    }

    @Test
    func invalidModuleNotLiteral() {
        let input = "#uuid(\"\(Self.validValue)\", module: value)"
        let expectedResult = input

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            diagnostics: [
                .expected(
                    message: "Argument 'module' is not a literal expression, "
                        + "passing in a runtime value is not supported."
                )
            ],
            macroSpecs: testMacros,
        )
    }

    @Test
    func invalidModule() {
        let input = "#uuid(\"\(Self.validValue)\", module: .value)"
        let expectedResult = input

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            diagnostics: [
                .expected(message: "'value' is not a valid Module case.")
            ],
            macroSpecs: testMacros,
        )
    }
}
