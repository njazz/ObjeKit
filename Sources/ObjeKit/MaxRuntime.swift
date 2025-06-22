//
//  MaxRuntime.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//

@_implementationOnly import MSDKBridge

/// Some wrappers for Max API
public enum MaxRuntime {
    internal static var _postImpl: (UnsafePointer<CChar>?) -> Void = poststring
    internal static var _warningImpl: (UnsafePointer<CChar>?) -> Void = _warning
    internal static var _errorImpl: (UnsafePointer<CChar>?) -> Void = _error

    public static func post(_ text: String) {
        let v = strdup(text)
        _postImpl(v)
        free(v)
    }

    public static func warning(_ text: String) {
        let v = strdup(text)
        _warningImpl(v)
        free(v)
    }

    public static func error(_ text: String) {
        let v = strdup(text)
        _errorImpl(v)
        free(v)
    }
}
