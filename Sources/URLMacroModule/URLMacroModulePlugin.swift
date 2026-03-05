// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct URLMacroPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [URLMacro.self]
}
