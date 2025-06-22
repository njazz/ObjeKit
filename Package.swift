// swift-tools-version:5.7
import PackageDescription

let sdkVersionSuffix = "-8.2"

let package = Package(
    name: "ObjeKit",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "DSPLKit",
            targets: ["DSPLKit"]
        ),
        .library(
            name: "ObjeKit",
            targets: ["ObjeKit"]
        ),
        .library(
            name: "MSDKBridge",
            targets: ["MSDKBridge"]
        ),
        .library(
            name: "MockSDK",
            targets: ["MockSDK"]
        ),
    ],
    dependencies: [
//        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
    ],
    targets: [
        
        .target(
            
                    name: "MSDKBridge",
                    path: "Sources/MSDKBridge",
                    
                    publicHeadersPath: "include",
                   
                    cSettings: [
                        .headerSearchPath("include"),
                        .headerSearchPath("../../ThirdParty/max-sdk\(sdkVersionSuffix)/source/max-sdk-base/c74support/max-includes"),
                        .headerSearchPath("../../ThirdParty/max-sdk\(sdkVersionSuffix)/source/max-sdk-base/c74support/msp-includes"),
                    ],
                    cxxSettings: [
                                   .unsafeFlags(["-std=c++17"])
                               ]
                ),
        
            .target(
            name: "DSPLKit",
            path: "Sources/DSPLKit"
        ),
        
        .target(
            name: "ObjeKit",
            dependencies: ["MSDKBridge", "DSPLKit"],
            
            path: "Sources/ObjeKit",
            cSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("../../ThirdParty/max-sdk\(sdkVersionSuffix)/source/max-sdk-base/c74support/max-includes"),
                .headerSearchPath("../../ThirdParty/max-sdk\(sdkVersionSuffix)/source/max-sdk-base/c74support/msp-includes"),
            ],
            
            plugins: [
//                            .plugin(name: "SwiftDocCPlugin", package: "swift-docc-plugin")
                .plugin(name: "docc")
                        ]
        ),
        
        .target(
            name: "MockSDK",
            path: "Sources/MockSDK",
            cSettings: [
                .headerSearchPath("../../ThirdParty/max-sdk\(sdkVersionSuffix)/source/max-sdk-base/c74support/max-includes"),
                .headerSearchPath("../../ThirdParty/max-sdk\(sdkVersionSuffix)/source/max-sdk-base/c74support/msp-includes"),
            ]
        ),
        
        .testTarget(
                    name: "ObjeKitTests",
                    dependencies: ["MSDKBridge", "ObjeKit", "MockSDK"],
                    cSettings: [
                        .headerSearchPath("include"),
                        .headerSearchPath("../../ThirdParty/max-sdk\(sdkVersionSuffix)/source/max-sdk-base/c74support/max-includes"),
                        .headerSearchPath("../../ThirdParty/max-sdk\(sdkVersionSuffix)/source/max-sdk-base/c74support/msp-includes"),
                    ]
                ),
        

    ]
    
)

// rename: ObjeKit


