// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "ProtocolProxy",

    platforms: [
        .iOS("9.0"),
        .macOS("10.10"),
        .tvOS("9.0"),
        .watchOS("2.0")
    ],

    products: [
        .library(name: "ProtocolProxy", targets: ["ProtocolProxy", "ProtocolProxySwift"])
    ],

    targets: [
        .target(name: "ProtocolProxy"),
        .target(name: "ProtocolProxySwift", dependencies: ["ProtocolProxy"]),

        .target(name: "ProtocolProxyTestsBase", path: "Tests/ProtocolProxyTestsBase"),
        .testTarget(name: "ProtocolProxyObjCTests", dependencies: ["ProtocolProxy", "ProtocolProxySwift", "ProtocolProxyTestsBase"]),
        .testTarget(name: "ProtocolProxySwiftTests", dependencies: ["ProtocolProxy", "ProtocolProxySwift", "ProtocolProxyTestsBase"])
    ],

    swiftLanguageVersions: [.version("5")]
)
