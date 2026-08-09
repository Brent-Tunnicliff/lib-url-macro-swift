// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import CommonMacroHelpers
import SwiftSyntax

extension LabeledExprSyntax {
    var module: Module? {
        get throws {
            guard let member = expression.as(MemberAccessExprSyntax.self) else {
                throw Module.Error.moduleNotLiteral
            }

            let moduleName = member.declName.baseName.text

            // If an invalid module is set, then throw error.
            guard let module = Module(rawValue: moduleName) else {
                throw Module.Error.moduleInvalid(moduleName)
            }

           return module
        }
    }
}

extension Module {
    enum Error: Swift.Error {
        case moduleInvalid(String)
        case moduleNotLiteral

        var description: String {
            switch self {
            case let .moduleInvalid(value): "'\(value)' is not a valid module case"
            case .moduleNotLiteral: "Module not a literal expression, passing in a runtime value is not supported"
            }
        }
    }
}
