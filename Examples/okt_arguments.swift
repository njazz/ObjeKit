//
//  ObjeKit.swift
//  ObjeKitTest
//
//  Created by alex on 21/06/2025.
//

import ObjeKit

@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
    MaxDispatcher.setup(ObjeKitTest_Arguments.self)
}

/// small class to display agrument values
class ObjeKitTest_Arguments : MaxObject {
    static var className: String { "okt_arguments"}
    
    required init() {
        MaxRuntime.post("init: okt_arguments")
    }
    
    deinit {
        MaxRuntime.post("deinit: okt_arguments")
    }
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        Argument(optional:false, "required argument, string") {
            (v:String) in
            MaxRuntime.post("okt_arguments required string argument value: \(v)")
        }
        Argument("optional argument, int") { (v:Int) in
            MaxRuntime.post("okt_arguments optional int argument value: \(v)")
        }
    }
}
