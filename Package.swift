// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUICardInfo",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .watchOS(.v7),
        .tvOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftUICardInfo",
            targets: ["SwiftUICardInfo"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "SwiftUIX", url: "https://github.com/SwiftUIX/SwiftUIX", from: "0.1.1"),
        .package(name: "URLImage", url: "https://github.com/dmytro-anokhin/url-image", from: "3.1.0"),
        .package(name: "Kingfisher", url: "https://github.com/onevcat/Kingfisher", from: "7.6.2"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols", from: "4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftUICardInfo",
            dependencies: ["SwiftUIX", "Kingfisher", "URLImage", "SFSafeSymbols"])
    ]
)
