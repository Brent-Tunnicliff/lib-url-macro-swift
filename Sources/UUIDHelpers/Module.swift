// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Module to hard code in the generated code.
public struct Module: Sendable {
    private let value: String
}

extension Module: CustomStringConvertible {
    /// A textual representation of this instance.
    public var description: String {
        value
    }
}

extension Module {
    /// Does not hard code any module, increasing the risk of conflicting with other symbols.
    public static let none = Module(value: "none")

    /// Hard codes the `Foundation` module.
    public static let foundation = Module(value: "foundation")

    /// Hard codes the `FoundationEssentials` module.
    public static let foundationEssentials = Module(value: "foundationEssentials")
}
