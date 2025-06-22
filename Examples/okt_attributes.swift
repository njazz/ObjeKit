//
//  okt_attributes.swift
//  ObjeKitTest
//
//  Created by Alex Nadzharov on 22/06/2025.
//

import ObjeKit

@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
    MaxDispatcher.setup(ObjeKitTest_Attributes.self)
}

/// small class to load / store attributes
class ObjeKitTest_Attributes : MaxObject {
    static var className: String { "okt_attributes"}
    
    required init() {
        MaxRuntime.post("init: okt_attributes")
    }
    
    deinit {
        MaxRuntime.post("deinit: okt_attributes")
    }
    
    @MaxState
    var intValue: CLong = 0
    
    @MaxState
    var floatValue: Double = 0
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        Attribute("intValue") { self.$intValue }
        Attribute("floatValue") { self.$floatValue }
        
        Outlet() { self.$intValue }
        Outlet() { self.$floatValue }
    }
}
