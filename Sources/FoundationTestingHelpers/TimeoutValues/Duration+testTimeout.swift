// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Duration {
    /// Default test timeout value.
    public static var testTimeout: Self { .seconds(.testTimeout) }
}
