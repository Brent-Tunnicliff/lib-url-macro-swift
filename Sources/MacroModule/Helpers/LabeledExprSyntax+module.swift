// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import CommonMacroHelpers
import SwiftSyntax
import SwiftSyntaxBuilder

extension LabeledExprSyntax {
    var module: Module? {
        get throws {
            guard let member = expression.as(MemberAccessExprSyntax.self) else {
                throw CommonError.argumentNotLiteral(name: "module")
            }

            let moduleName = member.declName.baseName.text

            // If an invalid module is set, then throw error.
            guard let module = Module(rawValue: moduleName) else {
                throw CommonError.argumentInvalid(value: moduleName, name: "Module case")
            }

            return module
        }
    }
}
