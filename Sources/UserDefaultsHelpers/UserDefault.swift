// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(SwiftUI)

    import Combine
    import Foundation
    public import SwiftUI

    /// Property wrapper that observes a `UserDefaults` value via compiler checked key path.
    ///
    /// While `@AppStorage` does the same logic, it uses strings to manage the value, whereas this one uses
    /// key path instead to make it compile time checked, and also can take advantage of the publisher support of UserDefaults.
    @MainActor
    @propertyWrapper
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    public struct UserDefault<Value>: DynamicProperty where Value: Equatable {
        @State
        private var store: Store

        /// A binding to the value.
        public var projectedValue: Binding<Value> {
            Binding(
                get: { wrappedValue },
                set: { wrappedValue = $0 }
            )
        }

        /// The wrapped object.
        public var wrappedValue: Value {
            get { store.value }
            nonmutating set {
                store.update(newValue)
            }
        }

        /// Initialises wrapper of a single property of `UserDefaults`.
        ///
        /// - Parameters:
        ///   - key: Key path reference to the value to be wrapped. Must conform to `@objc dynamic` for syncing UserDefaults changes back to `wrappedValue`.
        ///   - userDefaults: The instance of `UserDefaults` to observe. Defaults to `.standard`,
        ///
        ///   Keeps the value synced if the userDefaults new value does not equal the current one.
        public init(_ key: ReferenceWritableKeyPath<UserDefaults, Value>, userDefaults: UserDefaults = .standard) {
            self._store = State(wrappedValue: Store(key: key, userDefaults: userDefaults))
        }
    }

    // MARK: - UserDefault.Store

    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    extension UserDefault {
        @MainActor
        @Observable
        final class Store {
            private(set) var value: Value

            private let key: ReferenceWritableKeyPath<UserDefaults, Value>
            private let userDefaults: UserDefaults

            @ObservationIgnored
            private var syncingTask: Task<Void, Never>?

            init(
                key: ReferenceWritableKeyPath<UserDefaults, Value>,
                userDefaults: UserDefaults,
            ) {
                self.key = key
                self.userDefaults = userDefaults
                self.value = userDefaults[keyPath: key]

                // Listen for updates to user defaults and update the local value.
                // This will only work if the key path reference has been set as `@objc dynamic`,
                // but checking for it when dealing with these dynamic types and generics
                // is more complicated than is probably needed.
                // If not declared then it just means this stream will never update.
                let syncStream = userDefaults.publisher(for: key).values
                self.syncingTask = Task { [weak self] in
                    for await newValue in syncStream {
                        guard let self else {
                            return
                        }

                        if value != newValue {
                            value = newValue
                        }
                    }
                }
            }

            deinit {
                // Cancel the syncing task.
                syncingTask?.cancel()
            }

            func update(_ value: Value) {
                self.value = value
                userDefaults[keyPath: key] = value
            }
        }
    }

#endif
