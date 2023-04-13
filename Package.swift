// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ElegantEmojiPicker",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "ElegantEmojiPicker",
            targets: ["ElegantEmojiPicker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ElegantEmojiPicker",
            path: "Sources",
            resources: [
                .process("Resources/Emoji Unicode 15.0.json"),
                .process("Resources/Icons.xcassets")
            ])
    ]
)
