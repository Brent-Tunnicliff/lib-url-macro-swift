// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation
import Testing

/// An instance of `UserDefaults` to be used for unit tests that automatically cleans up its data on deinit.
public final class TestUserDefaults: UserDefaults {
    private let suiteName: String

    /// Creates a unique instance of ``TestUserDefaults`` isolated from other instances.
    ///
    /// Uses a `UUID` as part of the suite name to make it unique.
    public convenience init?(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        self.init(suiteName: Self.generateSuiteName(file: file, function: function, line: line))
    }

    init?(suiteName: String) {
        Self.log(suiteName: suiteName, message: "Initialising TestUserDefaults")
        self.suiteName = suiteName
        super.init(suiteName: suiteName)

        // Lets wipe all data before returning in case there is any previous left over data.
        clearAllData()
    }

    deinit {
        Self.log(suiteName: suiteName, message: "De-initialising TestUserDefaults")
        clearAllData()

        // Force a synchronize.
        // Especially important for non-Darwin platforms that are not as reliable in auto saving.
        synchronize()
    }

    fileprivate static func generateSuiteName(
        file: StaticString,
        function: StaticString,
        line: UInt
    ) -> String {
        "\(UUID().uuidString):\(file):\(function):\(line)"
    }

    private func clearAllData() {
        for key in dictionaryRepresentation().keys {
            removeObject(forKey: key)
        }
    }

    private static func log(suiteName: String, message: String) {
        #if DEBUG
            print("[\(suiteName)] \(message)")
        #endif
    }
}

extension UserDefaults {
    private struct FailedToCreateTestUserDefaults: Error, CustomStringConvertible {
        let suiteName: String

        var description: String {
            "Failed to create TestUserDefaults with suiteName '\(suiteName)'"
        }
    }

    /// Creates a unique instance of ``TestUserDefaults`` isolated from other instances.
    ///
    /// Uses a `UUID` as part of the suite name to make it unique.
    public static func forTesting(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) throws -> TestUserDefaults {
        let suiteName = TestUserDefaults.generateSuiteName(file: file, function: function, line: line)
        guard let userDefaults = TestUserDefaults(suiteName: suiteName) else {
            throw FailedToCreateTestUserDefaults(suiteName: suiteName)
        }

        return userDefaults
    }
}
