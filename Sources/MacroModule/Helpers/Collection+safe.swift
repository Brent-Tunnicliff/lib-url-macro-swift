// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import SwiftSyntax

extension Collection {
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }
}

extension Collection where Index == SyntaxChildrenIndex {
    subscript(safe offset: Int) -> Element? {
        guard offset < count else {
            return nil
        }

        return self[safe: index(startIndex, offsetBy: offset)]
    }
}
