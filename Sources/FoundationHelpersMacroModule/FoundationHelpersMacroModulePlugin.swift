// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct FoundationHelpersMacroModulePlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [
        URLMacro.self,
        UUIDMacro.self,
    ]
}
