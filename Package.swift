// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MaxAPIKit",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "MaxAPIKit",
            targets: ["MaxAPIKit"]
        ),
    ],
    dependencies: [
        // any dependencies if needed
    ],
    targets: [
//        .target(
//            name: "MaxSDK",
//            dependencies: [],
//            path: "Sources/MaxSDK",
//            publicHeadersPath: ".",
//            cSettings: [
//                .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/max-includes"),
//                .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/msp-includes")
//               
//            ]
//        ),
//        .target(
//            name: "max_c_wrapper",
//            path: "Sources/max_c_wrapper",
//            publicHeadersPath: ".",
//            cSettings: [
//                .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/max-includes"),
//                .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/msp-includes")
//               
//            ],
//            linkerSettings: [
//                // e.g. .linkedLibrary("max"), .unsafeFlags(["-L/path/to/libs"])                
//            ]
//        ),
        
        .target(
                    name: "MaxSDKBridge",
                    path: "Sources/MaxSDKBridge",
                    publicHeadersPath: "include",
                    cSettings: [
                        .headerSearchPath("include"),
                        .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/max-includes"),
                        .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/msp-includes")
                    ]
                ),
        
        .target(
            name: "MaxAPIKit",
            dependencies: ["MaxSDKBridge"/*, "MaxSDK"*/],
            path: "Sources/MaxAPIKit",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/max-includes"),
                .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/msp-includes")
                // If you have libs to link, might add linkerSettings below
            ]
        ),
        
            .target(
                name: "TestObject",
                dependencies: [/*"max_c_wrapper", */"MaxAPIKit"],
                path: "Sources/TestObject",
                
                
                cSettings: [
                    .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/max-includes"),
                    .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/msp-includes")
                ],
                swiftSettings: [
                    // probably none or optimize for release
                ],
                
                linkerSettings: [
                    // link flags if needed
                    // example: .linkedLibrary("max"), .unsafeFlags(["-L../../ThirdParty/max-sdk/lib"])
                ]
                
            )
        
//        .testTarget(
//            name: "MaxAPIKitTests",
//            dependencies: ["MaxAPIKit"],
//            path: "Tests/MaxAPIKitTests"
//        ),
    ]
)
