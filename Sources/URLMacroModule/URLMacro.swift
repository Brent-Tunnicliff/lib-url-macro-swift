// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import SwiftSyntax
import SwiftSyntaxBuilder
public import SwiftSyntaxMacros

#if canImport(FoundationEssentials)
    import FoundationEssentials
#elseif canImport(Foundation)
    import Foundation
#else
    #error("URLMacro requires Foundation or FoundationEssentials")
#endif

public struct URLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let argument = node.arguments.first?.expression,
            let literal = argument.as(StringLiteralExprSyntax.self),
            case .stringSegment(let segment) = literal.segments.first
        else {
            throw Error.notStringLiteral
        }

        let text = segment.content.text
        guard URL(string: text) != nil else {
            throw Error.invalidURL(text)
        }

        // Force unwrapping should be safe because the build would have failed if this returned nil.
        #if canImport(FoundationEssentials)
            return "FoundationEssentials.URL(string: \(argument))!"
        #elseif canImport(Foundation)
            return "Foundation.URL(string: \(argument))!"
        #endif
    }
}

extension URLMacro {
    enum Error {
        case notStringLiteral
        case invalidURL(String)
    }
}

extension URLMacro.Error: CustomStringConvertible {
    var description: String {
        switch self {
        case .notStringLiteral: "Argument is not a string literal"
        case let .invalidURL(value): "'\(value)' is not a valid URL"
        }
    }
}

extension URLMacro.Error: Swift.Error {}
