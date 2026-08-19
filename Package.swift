// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import CompilerPluginSupport
import PackageDescription

let nonDarwinDependencyCondition = TargetDependencyCondition.when(
    platforms: [
        .android,
        .linux,
        .openbsd,
        .wasi,
        .windows,
    ]
)

// MARK: - Package

let package = Package(
    name: "foundation-helpers",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "ConcurrencyHelpers",
            targets: ["ConcurrencyHelpers"]
        ),
        .library(
            name: "TestingHelpers",
            targets: ["TestingHelpers"]
        ),
        .library(
            name: "URLHelpers",
            targets: ["URLHelpers"]
        ),
        .library(
            name: "UserDefaultsHelpers",
            targets: ["UserDefaultsHelpers"]
        ),
        .library(
            name: "UUIDHelpers",
            targets: ["UUIDHelpers"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/Brent-Tunnicliff/swift-format-plugin", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "603.0.0"),
    ],
    targets: [
        .target(name: "CommonMacroHelpers"),

        .target(
            name: "ConcurrencyHelpers",
            dependencies: [
                .product(name: "NIOConcurrencyHelpers", package: "swift-nio", condition: nonDarwinDependencyCondition)
            ]
        ),
        .testTarget(
            name: "ConcurrencyHelpersTests",
            dependencies: [
                "ConcurrencyHelpers"
            ]
        ),

        .macro(
            name: "MacroModule",
            dependencies: [
                "CommonMacroHelpers",
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "MacroModuleTests",
            dependencies: [
                "CommonMacroHelpers",
                "MacroModule",
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
            ]
        ),

        .target(
            name: "TestingHelpers",
            dependencies: [
                "ConcurrencyHelpers"
            ]
        ),
        .testTarget(
            name: "TestingHelpersTests",
            dependencies: [
                "TestingHelpers"
            ]
        ),

        .target(
            name: "URLHelpers",
            dependencies: [
                "CommonMacroHelpers",
                "MacroModule",
            ]
        ),
        .testTarget(
            name: "URLHelpersTests",
            dependencies: [
                "CommonMacroHelpers",
                "URLHelpers",
            ]
        ),

        .target(name: "UserDefaultsHelpers"),
        .testTarget(
            name: "UserDefaultsHelpersTests",
            dependencies: [
                "TestingHelpers",
                "UserDefaultsHelpers",
            ]
        ),

        .target(
            name: "UUIDHelpers",
            dependencies: [
                "CommonMacroHelpers",
                "MacroModule",
            ]
        ),
        .testTarget(
            name: "UUIDHelpersTests",
            dependencies: [
                "CommonMacroHelpers",
                "UUIDHelpers",
            ]
        ),
    ]
)

// MARK: - Common target settings

// Sets values that are common for every target.
// Plugins cannot contain plugins or swift settings.
for target in package.targets where target.type != .plugin {
    // MARK: Plugins

    let commonPlugins: [PackageDescription.Target.PluginUsage] = [
        .plugin(name: "LintBuildPlugin", package: "swift-format-plugin")
    ]

    target.plugins = (target.plugins ?? []) + commonPlugins

    // MARK: Swift compliler settings

    let commonSwiftSettings: [PackageDescription.SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + commonSwiftSettings
}
