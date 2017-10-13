// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "TitanCore",
    products: [
        .library(name: "TitanCore", targets: ["TitanCore"])
    ],
    dependencies: [],
     targets:[
        .target(name:"TitanCore", dependencies: []),
        .testTarget(name: "TitanCoreTests", dependencies: ["TitanCore"])
    ]
)