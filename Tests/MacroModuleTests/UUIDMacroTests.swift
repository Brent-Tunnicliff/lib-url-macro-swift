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
        "00000000-0000-0000-0000-000000000000":
            "(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)",
        "8d336825-4b48-4104-b30e-76949888089d":
            "(0x8d, 0x33, 0x68, 0x25, 0x4b, 0x48, 0x41, 0x04, 0xb3, 0x0e, 0x76, 0x94, 0x98, 0x88, 0x08, 0x9d)",
        "8D336825-4B48-4104-B30E-76949888089D":
            "(0x8d, 0x33, 0x68, 0x25, 0x4b, 0x48, 0x41, 0x04, 0xb3, 0x0e, 0x76, 0x94, 0x98, 0x88, 0x08, 0x9d)",
        "ffffffff-ffff-ffff-ffff-ffffffffffff":
            "(0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff)",
        validValue:
            "(0x01, 0x9f, 0xf0, 0x82, 0x5c, 0xfb, 0x72, 0x19, 0xa1, 0xeb, 0xf2, 0x7c, 0x2c, 0xc2, 0x24, 0xd1)",
    ]

    @Test(arguments: uuids)
    func valid(input: String, expectedOutput: String) {
        let input = "#uuid(\"\(input)\")"
        let expectedResult = "UUID(uuid: \(expectedOutput))"

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            macroSpecs: testMacros
        )
    }

    static var validWithModuleArguments: [(String, String, Module)] {
        var results: [(String, String, Module)] = []

        for (input, expectedOutput) in uuids {
            for module in Module.allCases {
                results.append((input, expectedOutput, module))
            }
        }

        return results
    }

    @Test(arguments: validWithModuleArguments)
    func validWithModule(input: String, expectedOutput: String, module: Module) {
        let input = "#uuid(\"\(input)\", module: .\(module.rawValue))"
        let expectedUrl = "UUID(uuid: \(expectedOutput))"
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
