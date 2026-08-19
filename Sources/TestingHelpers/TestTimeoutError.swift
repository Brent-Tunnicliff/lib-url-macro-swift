// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Error thrown when timing out a test.
public struct TestTimeoutError: Error {
    private let file: StaticString
    private let function: StaticString
    private let line: UInt
    private let column: UInt

    /// Creates an instance of ``TestTimeoutError`` with the details of the caller.
    public init(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line,
        column: UInt = #column
    ) {
        self.column = column
        self.file = file
        self.function = function
        self.line = line
    }
}

extension TestTimeoutError: CustomStringConvertible {
    /// A textual representation of this instance.
    public var description: String {
        "TimeoutError (\(file):\(function):\(line):\(column))"
    }
}
