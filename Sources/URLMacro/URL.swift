// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#elseif canImport(Foundation)
    public import Foundation
#else
    #error("URLMacro requires Foundation or FoundationEssentials")
#endif

/// Macro for checking if url is valid at compile time and removing the usual optional.
///
/// - Parameter value: static string to be used for creating the url. If not a valid url then a compile error is thrown.
@freestanding(expression)
public macro url(_ value: StaticString) -> URL = #externalMacro(module: "URLMacroModule", type: "URLMacro")
