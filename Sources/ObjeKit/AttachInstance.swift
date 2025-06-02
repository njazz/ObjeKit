//
//  MaxObjectAttach.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//
//@_implementationOnly import MSDKBridge

@_implementationOnly import MSDKBridge

/// Attach DispatcherClass instance to max object instance
class AttachInstance: MaxIOVisitor {
    var object : UnsafeMutablePointer<t_object>
    var wrapper : DispatcherClass
    
    var currentArgumentIndex : UInt = 0
    var currentArgumentIsOptional = false
    
    init(_ object: UnsafeMutablePointer<t_object>, wrapper: DispatcherClass) {
        self.object = object
        self.wrapper = wrapper
    }
    
    func visit<T>(_ inlet: Inlet<T>) {
        MaxRuntime.post("\((object)) : Registering inlet with value: \(inlet.wrappedValue)")
        
        let this_inlet = inlet_new(self.object, nil)
    }
    
    func visit<T>(_ outlet: Outlet<T>) {
        MaxRuntime.post("\((object)) : Registering outlet with value: \(outlet.wrappedValue)")
        
        let this_outlet = outlet_new(self.object, nil)
        
        outlet.onChange = { [this_outlet] value in
            MaxRuntime.post("outlet")
            outlet_bang(this_outlet)
        }
        
    }
    
    func visit(_ method: MaxMethod) {
        MaxRuntime.post("\((object)) : Registering method \(method.kind)")
        
        switch method.kind {
        case .bang:
            wrapper.onBang = method.callAsBang
        case .int:
            wrapper.onInt = method.callAsInt
        case .float:
            wrapper.onDouble = method.callAsFloat
        case .selector(let name):
            wrapper.onSelector[name] = method.callAsSelector
        case .list:
            wrapper.onList = method.callAsSelector
        }
    }
    
    func visit<T: MaxValueConvertible>(_ argument: Argument<T>) -> Bool {
        MaxRuntime.post("\((object)) : Registering \(argument.optional ? "optional ":"")argument at \(currentArgumentIndex) \(argument.description != nil ? "(\(argument.description!))" : "" )")
        
        if (!argument.optional && currentArgumentIsOptional){
            MaxRuntime.warning("\((object)) : Non-optional argument at index \(currentArgumentIndex) following optional one")
        }
        
        if (!currentArgumentIsOptional && argument.optional) { currentArgumentIsOptional = true }
        
        
        let untypedSetter = { (v:MaxValue) in
            
            let value = v.convert(to: T.self)
            
            if value == nil {
                MaxRuntime.error("\((self.object)) : bad argument value provided, expected: \(T.self)")
                return false
            }
            
            argument.setter(value!)
            return true
        }
        
        wrapper.arguments.append(
            ArgumentData(untypedSetter: untypedSetter,
                         optional: argument.optional,
                         description: argument.description)
        )
        
        currentArgumentIndex += 1
        
        if !currentArgumentIsOptional
        {
            wrapper.requiredArguments += 1
        }
        
        MaxRuntime.post("...done");
        
        return true
    }
}

// MARK: -


