//
//  Logger.swift
//  ObjeKit
//
//  Created by alex on 22/06/2025.
//

@_implementationOnly import MSDKBridge

/// Extra wrap for logging
///
/// disabled in Release
public class MaxLogger {
    public static let shared = MaxLogger()

    private init() {}

    public func post(_ message: @autoclosure () -> String) {
        #if DEBUG
            MaxRuntime.post(message())
        #endif
    }

    public func warning(_ message: @autoclosure () -> String) {
        #if DEBUG
            MaxRuntime.warning(message())
        #endif
    }

    public func error(_ message: @autoclosure () -> String) {
        #if DEBUG
            MaxRuntime.error(message())
        #endif
    }
}
