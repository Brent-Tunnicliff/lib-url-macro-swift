// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import SwiftSyntax

extension Collection {
    /// Allows safe access to an element, returning nil if there is none.
    ///
    /// Uses offset so it also works with types that don't use Int as their Index.
    subscript(safe offset: Int) -> Element? {
        guard offset >= 0, offset < count else {
            return nil
        }

        let index = index(startIndex, offsetBy: offset)
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }
}
