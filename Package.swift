// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MaxAPIKit",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "MaxAPIKit",
            targets: ["MaxAPIKit"]
        ),
        .library(
            name: "MaxSDKBridge",
            targets: ["MaxSDKBridge"]
        ),
    ],
    dependencies: [
        
    ],
    targets: [

        .target(
                    name: "MaxSDKBridge",
                    path: "Sources/MaxSDKBridge",
                    publicHeadersPath: "include",
                    cSettings: [
                        .headerSearchPath("include"),
                        .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/max-includes"),
                        .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/msp-includes"),
                    ]
                ),
        
        .target(
            name: "MaxAPIKit",
            dependencies: ["MaxSDKBridge"],
            path: "Sources/MaxAPIKit"
            ,
            cSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/max-includes"),
                .headerSearchPath("../../ThirdParty/max-sdk/source/max-sdk-base/c74support/msp-includes"),
            ]
        )

    ]
    
)
