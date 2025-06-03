//
//  MaxSDKKitTest.swift
//  max-sdk-kit-test
//
//  Created by alex on 25/05/2025.
//

import ObjeKit

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
    
    @MaxState
    var bangOutlet : MaxList = []
    
    @MaxOutput()
    var testOutlet
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        
        // MARK: - builder: arguments
        
        Argument(optional:false, description: "required argument, string") { (v:String) in }
        Argument( description: "optional argument, int") { (v:Int) in }
        
        // MARK: - builder:  methods
        Inlet(name:"method1")
        {
            MaxRuntime.post("method1")
        }
        
        Inlet() {
            self.value += 1
            MaxRuntime.post("bang! value: \(self.value)")
        }
        
        Inlet() { (value : Double) in
            MaxRuntime.post("float: \(value)")
        }
        
        Inlet() { (value : CLong) in
            MaxRuntime.post("int: \(value)")
        }
                
        Inlet(name:"test") { value in
//            self.inlet2 = 0
            MaxRuntime.post("test: \(value)")
        }
        
        Inlet() { (value:[MaxValue]) in
            MaxRuntime.post("list: \(value)")
            self.testOutlet.bang()
        }
        
        // MARK: - builder:  I/O
        Inlet(.index(1)) { }

        Outlet(.index(0)) { self.$value }
        Outlet { self.$value }
        
//        Outlet { self.$bangOutlet }
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


