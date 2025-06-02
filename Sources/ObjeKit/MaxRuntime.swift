//
//  MaxRuntime.swift
//  ObjeKit
//
//  Created by alex on 25/05/2025.
//

@_implementationOnly import MSDKBridge

/// Some wrappers for Max API
public enum MaxRuntime {
    public static func post(_ text: String) {
        poststring(text)        
    }
}
