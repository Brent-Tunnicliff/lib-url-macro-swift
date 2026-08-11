// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import CommonMacroHelpers

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

/// Macro for checking if uuid string is valid at compile time and removing the usual optional.
///
/// - Parameters:
///    - value: String literal to be used for creating the uuid. If not a valid uuid then a compile error is thrown.
///    - module: Module to hard code in the generated code. By default it will not add the module meaning conflicting with local symbols is possible.
///    This must be a literal reference to the value, passing in a runtime value will throw a compile error.
@freestanding(expression)
public macro uuid(
    _ value: StaticString,
    module: Module = .none
) -> UUID = #externalMacro(module: "MacroModule", type: "UUIDMacro")
