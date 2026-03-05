// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

/// Example type to be replaced in the real project.
public final class Example: Sendable {
    /// Shared instance of ``Example``.
    public static let shared = Example()

    /// Get hello world message.
    public func getMessage() -> String {
        "Hello, World!"
    }

    private init() {}
}
