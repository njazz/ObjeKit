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
    
//    func visit<T>(_ inlet: Inlet<T>) {
//        MaxRuntime.post("\((object)) : Registering inlet with value: \(inlet.wrappedValue)")
//        
//        let this_inlet = inlet_new(self.object, nil)
//    }
    
    func visit<T/*: MaxValueConvertible*/>(_ outlet: Outlet<T>) {
        MaxRuntime.post("\((object)) : Registering outlet with value: \(outlet.wrappedValue)")
        
        // add inlets accordingly
//        if case .available = outlet.index {
        
        let this_outlet = outlet_new(self.object, nil)
        if this_outlet != nil  { wrapper.outlets.append(this_outlet!) }
        
//        }
        
        outlet.onChange = { [this_outlet] value in
//
            if T.Type.self == MaxList.self {
                let v = value as? MaxList
                if v?.count == 0 {
                    MaxRuntime.post("outlet bang")
                    outlet_bang(this_outlet)
                }
                else {
                    let atoms = makeAtomPointer(from: v!.asAtoms )
                    outlet_list(this_outlet, nil, Int16(atoms.argc), atoms.argv)
                    // NB list size is limited to 256
                    MaxRuntime.post("outlet list \(atoms)")
                }
                
            }
        }
        
    }
    
    func visit(_ inlet: Inlet) {
        MaxRuntime.post("\((object)) : Registering method \(inlet.kind)")
        
        switch inlet.kind {
        case .bang:
            wrapper.onBang = inlet.callAsBang
        case .int:
            wrapper.onInt = inlet.callAsInt
        case .float:
            wrapper.onDouble = inlet.callAsFloat
        case .selector(let name):
            wrapper.onSelector[name] = inlet.callAsSelector
        case .list:
            wrapper.onList = inlet.callAsSelector
        }
        
        // add inlets accordingly
        if case .available = inlet.index{
            let this_inlet = inlet_new(self.object, nil)
            if this_inlet != nil { wrapper.inlets.append(this_inlet!) }
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


