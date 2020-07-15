// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Badgy",
    products: [
        .executable(name: "badgy", targets: ["Badgy"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/jakeheis/SwiftCLI",
            from: "6.0.0"
        ),
        .package(
            url: "https://github.com/kylef/PathKit",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "0.1.0"
	),
	.package(
            url: "https://github.com/nicklockwood/SwiftFormat",
            from: "0.44.17"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Badgy",
            dependencies: [
                "SwiftCLI",
                "PathKit",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "BadgyTests",
            dependencies: ["Badgy"]),
    ]
)
