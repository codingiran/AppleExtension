// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppleExtension",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppleExtension",
            targets: ["AppleExtension"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/codingiran/ObjCExceptionCatcher.git", .upToNextMajor(from: "1.0.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppleExtension",
            dependencies: [
                "ObjCExceptionCatcher",
            ],
            resources: [.copy("Resources/PrivacyInfo.xcprivacy")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
