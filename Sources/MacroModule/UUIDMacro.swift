// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import CommonMacroHelpers
public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

/// Macro for checking if uuid is valid at compile time and removing the usual optional.
public struct UUIDMacro: ExpressionMacro {
    /// Expand a macro described by the given freestanding macro expansion within the given context to produce a replacement expression.
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        try uuidSyntax(of: node)
            .applying(module: try node.arguments[safe: 1]?.module)
    }

    private static func uuidSyntax(of node: some FreestandingMacroExpansionSyntax) throws -> ExprSyntax {
        guard let argument = node.arguments.first?.expression else {
            throw CommonError.argumentMissing(index: 0)
        }

        guard
            let literal = argument.as(StringLiteralExprSyntax.self),
            case .stringSegment(let segment) = literal.segments.first
        else {
            throw CommonError.argumentNotLiteral(name: "uuid")
        }

        let text = segment.content.text
        guard UUID(uuidString: text) != nil else {
            throw CommonError.argumentInvalid(value: text, name: "UUID")
        }

        // Force unwrapping should be safe because the build would have failed if this returned nil.
        return "UUID(uuidString: \(argument))!"
    }
}
