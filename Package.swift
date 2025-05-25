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
                    .unsafeFlags([
                            "-dynamiclib",
                            "-o", "TestObject.mxo",
                            "-install_name", "@rpath/TestObject.mxo"
                        ])
                    // link flags if needed
                    // example: .linkedLibrary("max"), .unsafeFlags(["-L../../ThirdParty/max-sdk/lib"])
                ]
                
            ),
        

    ]
)
