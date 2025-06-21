//
//  MaxSDKKitTest.swift
//  max-sdk-kit-test
//
//  Created by alex on 25/05/2025.
//

import ObjeKit

/// Simple test: one inlet / one outlet, several methods
class ObjeKitTest_Simple : MaxObject {
    static var className: String { "okt_simple"}
    
    required init() {
        MaxRuntime.post("init: okt_simple")
    }
    
    deinit {
        MaxRuntime.post("deinit: okt_simple")
    }
    
    // MARK: - state objects
    
    @MaxState
    var floatValue : Double = 0
    
    @MaxState
    var intValue : CLong = 0
    
    @MaxState
    var listValue : MaxList = []
    
    @MaxOutput()
    var directOutlet
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        
        // MARK: - builder:  methods
        
        Inlet() {
            self.floatValue += 1
            MaxRuntime.post("bang! incremented value: \(self.floatValue)")
        }
        
        Inlet() { (value : Double) in
            self.floatValue = value
            MaxRuntime.post("float: \(value)")
        }
        
        Inlet() { (value : CLong) in
            self.intValue = value
            MaxRuntime.post("int: \(value)")
        }
        
        Inlet(name:"method_one")
        {
            MaxRuntime.post("method_one called")
            self.directOutlet.bang()
        }
                
        Inlet(name:"method_any") { value in
            MaxRuntime.post("method_any called with value: \(value)")
            self.listValue = value
        }
        
        Inlet() { (value:[MaxValue]) in
            MaxRuntime.post("received list: \(value)")
        }
        
        // MARK: - builder:  Outlets
        Outlet(.index(0)) { self.$floatValue }
        Outlet { self.$intValue }
        Outlet { self.$listValue }
    }
    
}


@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
    MaxDispatcher.setup(ObjeKitTest_Simple.self)
}


