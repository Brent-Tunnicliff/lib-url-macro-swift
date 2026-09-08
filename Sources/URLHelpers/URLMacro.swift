// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

/// Macro for checking if url is valid at compile time and removing the usual optional.
///
/// - Parameters:
///    - value: String literal to be used for creating the url. If not a valid url then a compile error is thrown.
///    - module: Module to hard code in the generated code. By default it will not add the module meaning conflicting with local symbols is possible.
///    This must be a literal reference to the value, passing in a runtime value will throw a compile error.
@freestanding(expression)
public macro url(_ value: StaticString, module: Module = .none) -> URL =
    #externalMacro(module: "FoundationHelpersMacroModule", type: "URLMacro")
