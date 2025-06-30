//
//  File.swift
//  
//
//  Created by Alex on 23.06.2025.
//

import Foundation

import ObjeKit

@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
    MaxDispatcher.setup(ObjeKitTest_IO.self)
}

/// Object with multiple ins and outs
class ObjeKitTest_IO : MaxObject {
    static var className: String { "okt_io" }
    
    required init() {}
    
    @MaxState
    var output1 : Double = 0
    
    @MaxState
    var output2 : CLong = 0
    
    @MaxState
    var output3 : MaxList = []
    
    // MARK: -
    @MaxState
    var methodOutput1A : MaxList = []
    
    @MaxState
    var methodOutput1B : MaxList = []
    
    @MaxState
    var methodOutput2 : MaxList = []
    
    // MARK: -
    
    @MaxOutput(.index(0))
    var directOutput1
    
    @MaxOutput(.index(1))
    var directOutput2
    
    @MaxOutput(.index(2))
    var directOutput3
    
    // MARK: -
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        Inlet(.index(0)) {
            (v:Double) in
            self.output1 += v
        }
        
        Inlet(.index(1)) {
            (v:CLong) in
            self.output2 += v
        }
        
        Inlet(.index(2)) {
            (v:MaxList) in
            self.output3.append(contentsOf: v)
        }
        
        // MARK: - methods with same names for different inlets
        
        Inlet(.index(0), name: "reset") { self.output1 = 0 }
        Inlet(.index(1), name: "reset") { self.output1 = 0 }
        Inlet(.index(2), name: "reset") { self.output1 = 0 }
        
        Inlet(.index(0), name: "set") { (v:MaxList) in if let v0 = v[0].convert(to: Double.self) { self.output1 = v0 } }
        Inlet(.index(1), name: "set") { (v:MaxList) in if let v0 = v[0].convert(to: CLong.self) { self.output2 = v0 } }
        Inlet(.index(2), name: "set") { (v:MaxList) in self.output3 = v }
        
        // MARK: -
        
        Inlet(.index(0), name: "method1_a") { (v:MaxList) in self.methodOutput1A = v }
        Inlet(.index(0), name: "method1_b") { (v:MaxList) in self.methodOutput1B = v }
        Inlet(.index(0), name: "method2") { (v:MaxList) in self.methodOutput2 = v }
        
        // MARK: -
        
        Outlet(.index(0)) { self.$output1 }
        Outlet(.index(1)) { self.$output2 }
        Outlet(.index(2)) { self.$output3 }
        
        Outlet(.index(0), name: "method1_a") { self.$methodOutput1A }
        Outlet(.index(0), name: "method1_b") { self.$methodOutput1B }
        
        Outlet(.index(1), name: "method2") { self.$methodOutput2 }
        
        }
    
}
