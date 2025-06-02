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
    
    @Inlet(2)
    var inlet2 : Int = 10
    
    @MaxState
    var value : Float = 3.3
    
    @MaxMethod("method1")
    var method1 = {
        MaxRuntime.post("method1")
    }
    
    @Argument(optional:false, description: "property argument")
    var arg0 = { (v:MaxValue) in }
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        
        Argument(wrappedValue:{ (v:MaxValue) in } , description: "builder argument") 
        
        Inlet() { (v:Int) in self.inlet2 = v }
        
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


