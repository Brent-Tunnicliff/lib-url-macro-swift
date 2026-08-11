// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import CommonMacroHelpers
import SwiftSyntax
import SwiftSyntaxBuilder

extension ExprSyntax {
    func applying(module: Module?) -> ExprSyntax {
        guard let name = module?.name else {
            return self
        }

        return "\(raw: name).\(self)"
    }
}
