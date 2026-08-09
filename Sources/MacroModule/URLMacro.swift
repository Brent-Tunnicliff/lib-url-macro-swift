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

/// Macro for checking if url is valid at compile time and removing the usual optional.
public struct URLMacro: ExpressionMacro {
    /// Expand a macro described by the given freestanding macro expansion within the given context to produce a replacement expression.
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let url = try urlSyntax(of: node)
        guard let moduleName = try foundationModuleName(of: node) else {
            return url
        }

        return "\(moduleName).\(url)"
    }

    private static func foundationModuleName(of node: some FreestandingMacroExpansionSyntax) throws -> ExprSyntax? {
        // If no module set, then return nil.
        guard let name = try node.arguments[safe: 1]?.module?.name else {
            return nil
        }

        return "\(raw: name)"
    }

    private static func urlSyntax(of node: some FreestandingMacroExpansionSyntax) throws -> ExprSyntax {
        guard
            let argument = node.arguments.first?.expression,
            let literal = argument.as(StringLiteralExprSyntax.self),
            case .stringSegment(let segment) = literal.segments.first
        else {
            throw Error.urlNotStringLiteral
        }

        let text = segment.content.text
        guard URL(string: text) != nil else {
            throw Error.urlInvalid(text)
        }

        // Force unwrapping should be safe because the build would have failed if this returned nil.
        return "URL(string: \(argument))!"
    }
}

extension URLMacro {
    enum Error: Swift.Error {
        case urlInvalid(String)
        case urlNotStringLiteral
    }
}

extension URLMacro.Error: CustomStringConvertible {
    var description: String {
        switch self {
        case .urlNotStringLiteral: "URL argument is not a string literal"
        case let .urlInvalid(value): "'\(value)' is not a valid URL"
        }
    }
}
