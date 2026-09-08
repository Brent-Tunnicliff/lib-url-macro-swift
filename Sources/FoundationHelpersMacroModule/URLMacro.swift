// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

/// Macro for checking if url is valid at compile time and removing the usual optional.
public struct URLMacro: ExpressionMacro {
    /// Expand a macro described by the given freestanding macro expansion within the given context to produce a replacement expression.
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        try urlSyntax(of: node)
            .applying(module: try node.arguments[safe: 1]?.module)
    }

    private static func urlSyntax(of node: some FreestandingMacroExpansionSyntax) throws -> ExprSyntax {
        guard let argument = node.arguments.first?.expression else {
            throw CommonError.argumentMissing(index: 0)
        }

        guard
            let literal = argument.as(StringLiteralExprSyntax.self),
            case .stringSegment(let segment) = literal.segments.first
        else {
            throw CommonError.argumentNotLiteral(name: "url")
        }

        let text = segment.content.text
        guard URL(string: text) != nil else {
            throw CommonError.argumentInvalid(value: text, name: "URL")
        }

        // Force unwrapping should be safe because the build would have failed if this returned nil.
        return "URL(string: \(argument))!"
    }
}
