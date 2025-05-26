//
//  MaxObjectAttach.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//
//@_implementationOnly import MaxSDKBridge

@_implementationOnly import MaxSDKBridge

func _addressOf<T : AnyObject>(_ object: T?) -> UInt {
    if object == nil { 0 } else {
        UInt(bitPattern: Unmanaged.passUnretained(object!).toOpaque())
    }
}

class MaxObjectAttach: MaxIOVisitor {
    var object : UnsafeMutablePointer<t_object>
    var wrapper : DispatcherClass
    
    init(_ object: UnsafeMutablePointer<t_object>, wrapper: DispatcherClass) {
        self.object = object
        self.wrapper = wrapper
    }
    
    func visit<T>(_ inlet: Inlet<T>) {
        // Example C API call - replace with your actual bridging logic
        MaxRuntime.post("\((object)) : Registering inlet with value: \(inlet.wrappedValue)")
        // c_api_register_inlet(...)
//        if (self.object == nil) { return }
        
        inlet_new(self.object, nil)
    }
    
    func visit<T>(_ outlet: Outlet<T>) {
        MaxRuntime.post("\((object)) : Registering outlet with value: \(outlet.wrappedValue)")
        // c_api_register_outlet(...)
        
        outlet_new(self.object, nil)
    }
    
    func visit(_ method: MaxMethod) {
        MaxRuntime.post("\((object)) : Registering method \(method.kind)")
        // c_api_register_method(...)
        
        switch method.kind {
        case .bang:
            wrapper.onBang = method.callAsBang
        case .int:
            wrapper.onInt = method.callAsInt
        case .float:
            wrapper.onDouble = method.callAsFloat
        case .selector(var name):
            wrapper.onSelector[name] = method.callAsSelector
        case .list:
            wrapper.onSelector[""] = method.callAsSelector
        }
    }
}

class MaxClassAttach : MaxIOVisitor {
    func visit<T>(_ inlet: Inlet<T>) {
        
    }
    
    func visit<T>(_ outlet: Outlet<T>) {
        
    }
    
    func visit(_ method: MaxMethod) {
        
    }
}
