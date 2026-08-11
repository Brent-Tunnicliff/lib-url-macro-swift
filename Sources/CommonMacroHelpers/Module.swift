// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

// MARK: - Module

/// Module to use in the generated the code.
public struct Module {
    private let value: Value
}

extension Module {
    /// Does not hard code any module, increasing the risk of conflicting with other symbols.
    public static let none = Module(value: .none)

    /// Hard codes the `Foundation` module.
    public static let foundation = Module(value: .foundation)

    /// Hard codes the `FoundationEssentials` module.
    public static let foundationEssentials = Module(value: .foundationEssentials)
}

extension Module {
    package var name: String? {
        switch value {
        case .none: return nil
        case .foundation: return "Foundation"
        case .foundationEssentials: return "FoundationEssentials"
        }
    }
}

// MARK: - Module.Value

extension Module {
    fileprivate enum Value: String {
        case none
        case foundation
        case foundationEssentials
    }
}

// MARK: - CaseIterable

extension Module: CaseIterable {
    /// A collection of all values of this type.
    public static let allCases = Value.allCases.map(Module.init(value:))
}

extension Module.Value: CaseIterable {}

// MARK: - CustomStringConvertible

extension Module: CustomStringConvertible {
    /// A textual representation of this instance.
    public var description: String { value.description }
}

extension Module.Value: CustomStringConvertible {
    var description: String { rawValue }
}

// MARK: - CustomDebugStringConvertible

extension Module: CustomDebugStringConvertible {
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        "foundation-helpers.CommonMacroHelpers.Module.\(rawValue)"
    }
}

// MARK: - Hashable

extension Module: Hashable {}
extension Module.Value: Hashable {}

// MARK: - RawRepresentable

extension Module: RawRepresentable {
    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw value, this initializer returns `nil`.
    public init?(rawValue: String) {
        guard let value = Value(rawValue: rawValue) else {
            return nil
        }

        self.value = value
    }

    /// The corresponding value of the raw type.
    public var rawValue: String {
        value.rawValue
    }
}

// MARK: - Sendable

extension Module: Sendable {}
extension Module.Value: Sendable {}
