//
//  File.swift
//  
//
//  Created by Alex on 23.06.2025.
//

import Foundation

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
    
    @MaxOutput(0)
    var directOutput1
    
    @MaxOutput(0)
    var directOutput2
    
    @MaxOutput(0)
    var directOutput3
    
    // MARK: -
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        Inlet(.index(0)) {
        
        }
        
        Inlet(.index(1)) {
        
        }
        
        Inlet(.index(2)) {
        
        }
        
        // MARK: -
        
        Outlet(.index(0)) { self.$output1 }
        Outlet(.index(1)) { self.$output2 }
        Outlet(.index(2)) { self.$output3 }
        
        Outlet(.index(0)) { self.$methodOutput1A }
        Outlet(.index(0)) { self.$methodOutput1B }
        
        Outlet(.index(1)) { self.$methodOutput2 }
        
        }
    
}
