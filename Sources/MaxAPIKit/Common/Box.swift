//
//  Box.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//


public class Box<T : Initializable > {
    var value: T

    public init(_ value: T) {
        self.value = value
    }

    public static func create(_ type: T.Type) -> Box<T> {
        Box(type.init())
    }

    public func toRaw() -> UnsafeMutableRawPointer {
        return Unmanaged.passRetained(self).toOpaque()
    }

    public static func fromRaw(_ ptr: UnsafeMutableRawPointer, _ type: T.Type) -> Unmanaged<Box<T>> {
        return Unmanaged<Box<T>>.fromOpaque(ptr)
    }

    func release() {
        Unmanaged.passUnretained(self).release()
    }
}