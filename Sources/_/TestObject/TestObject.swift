//
//  main.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//

import Foundation
import ObjeKit

// MARK: - Define a Swift Max Object

final class TestObject: MaxObject {
    func process() {
        
    }
    
    func cleanup() {
        
    }
    
    var className: String { get { "testobject" } }

//    required init(args: [Atom]) {
//        print("TestObject initialized with args: \(args)")
//        super.init(args: args)
//        outletBang()
//    }
//
//    @objc func bang(_ inlet: Int32) {
//        outletSymbol("hello_from_swift")
//    }
}

// MARK: - Entry Point

@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
//    MaxObject.register(TestObject.self, forDSP: false)
}
