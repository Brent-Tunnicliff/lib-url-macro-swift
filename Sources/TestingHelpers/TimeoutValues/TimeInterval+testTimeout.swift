// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation

extension TimeInterval {
    /// Default test timeout value.
    public static var testTimeout: Self { TimeInterval(Int.testTimeout) }
}
