// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#elseif canImport(Foundation)
    public import Foundation
#else
    #error("URLMacro requires Foundation or FoundationEssentials")
#endif

@freestanding(expression)
public macro url(_ value: StaticString) -> URL = #externalMacro(module: "URLMacroModule", type: "URLMacro")
