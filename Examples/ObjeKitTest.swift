//
//  MaxSDKKitTest.swift
//  max-sdk-kit-test
//
//  Created by alex on 25/05/2025.
//

import ObjeKit

import Cocoa
import SwiftUI

class ObjeKitTest : MaxObject {
    static var className: String { "objekit.test"}
    
    required init() {
        MaxRuntime.post("objekit test object: init")
    }
    
    deinit {
        MaxRuntime.post("objekit test object: deinit")
    }
    
    // MARK: - state objects
    
    @MaxState
    var value : Float = 3.3
    
    @MaxMethod("method1")
    var method1 = {
        MaxRuntime.post("method1")
    }
    
    // MARK: - inlets provided as property wrappers
    
    @Inlet(2)
    var inlet2 : Int = 10
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        
        // MARK: - builder: arguments
        
        Argument(optional:false, description: "required argument, string") { (v:String) in }
        Argument( description: "optional argument, int") { (v:Int) in }
        
        // MARK: - builder:  methods
        MaxMethod() {
            self.value += 1
            MaxRuntime.post("bang! value: \(self.value)")
        }
        
        MaxMethod() { (value : Double) in
            MaxRuntime.post("float: \(value)")
        }
        
        MaxMethod() { (value : CLong) in
            MaxRuntime.post("int: \(value)")
        }
                
        MaxMethod("test") { value in
            self.inlet2 = 0
            MaxRuntime.post("test: \(value)")
        }
        
        MaxMethod() { (value:[MaxValue]) in
            MaxRuntime.post("list: \(value)")
        }
        
        // MARK: - builder:  I/O
        Inlet() { (v:Int) in self.inlet2 = v }

        Outlet(0) { self.$value }
        Outlet { self.$value }
    }
    
//    @MaxObjectBuilder
//    var objects: any MaxObject {
//        Test()
//    }
    
}


@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
    MaxDispatcher.setup(ObjeKitTest.self)
}


