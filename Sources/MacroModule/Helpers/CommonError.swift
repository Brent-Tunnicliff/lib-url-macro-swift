// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

enum CommonError: Error {
    case argumentInvalid(value: String, name: String)
    case argumentMissing(index: Int)
    case argumentNotLiteral(name: String)
}

extension CommonError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .argumentInvalid(value, name):
            "'\(value)' is not a valid \(name)."
        case let .argumentMissing(index):
            "Argument at index '\(index)' is missing."
        case let .argumentNotLiteral(name):
            "Argument '\(name)' is not a literal expression, passing in a runtime value is not supported."
        }
    }
}
