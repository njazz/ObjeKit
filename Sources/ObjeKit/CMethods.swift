//
//  CMethods.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

@_implementationOnly import MSDKBridge

internal func _ctor(_ p: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    MaxRuntime.post ("input pointer: \(String(describing: p))")
    let ctor_ptr = unsafeBitCast(p, to: UnsafeRawPointer.self)
    
    let cls = MaxDispatcher._classMap["\(ctor_ptr)"]
    
    if (cls == nil){
        MaxRuntime.post ("class error: \(ctor_ptr)")
    }
    
    let obj = object_alloc(cls)
    if (obj==nil) { return nil }
    
        
    let typed_obj = obj!.assumingMemoryBound(to: t_wrapped_object.self) // as! UnsafeMutablePointer<t_wrapped_object>?

    t_wrapped_object_allocate_proxy(typed_obj)
    
    if let swiftClass = MaxDispatcher._swiftClassMap["\(ctor_ptr)"] {
        let box = Box.create(DispatcherClass.self)
        box.value.object = swiftClass.init()
        typed_obj.pointee.box = box.toRaw()
        
        // init
        let visitor = MaxObjectAttach(obj!.assumingMemoryBound(to: t_object.self), wrapper: box.value)
        
        let mirror = Mirror(reflecting: box.value.object!)
        // Gather all property wrappers conforming to MaxIOComponent
        let wrappers = mirror.children.compactMap { child -> MaxIOComponent? in
            // Property wrappers are stored under _propertyName, or sometimes with $propertyName, so we test both
            if let component = child.value as? MaxIOComponent {
                return component
            }
            return nil
        }
        
        // properties
        for component in wrappers {
            component.accept(visitor: visitor)
        }
                
        // build pattern
        box.value.object!.io.accept(visitor: visitor)

    }
    
    return obj
}

internal func _dtor(ptr: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    if (ptr==nil) { return nil }
    
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    
    t_wrapped_object_free_proxy(obj)
    
    let p = obj.pointee.box

    if p != nil { Box.fromRaw(p!, DispatcherClass.self).release() }
    return nil
}

// MARK: -

internal func _method_bang(_ ptr: UnsafeMutableRawPointer?) -> Void {
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    let p = obj.pointee.box
    if (p == nil) { return  }
    
    let dispatcher = Box.fromRaw(p!, DispatcherClass.self)
    
    dispatcher.takeUnretainedValue().value.onBang()
    
    return
}


internal func _method_int(_ ptr: UnsafeMutableRawPointer?, _ value: CLong) -> Void {
    
    
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    let p = obj.pointee.box
    if (p == nil) { return  }
    
    let dispatcher = Box.fromRaw(p!, DispatcherClass.self)
    
    dispatcher.takeUnretainedValue().value.onInt(value)
    
    return
}

internal func _method_float(_ ptr: UnsafeMutableRawPointer?, _ value: CDouble) -> Void {
    
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    let p = obj.pointee.box
    if (p == nil) { return  }
    
    let dispatcher = Box.fromRaw(p!, DispatcherClass.self)
    
    dispatcher.takeUnretainedValue().value.onDouble(value)
    
    return
}

internal func _method_list(_ ptr: UnsafeMutableRawPointer?, _ s: UnsafeMutablePointer<t_symbol>?, _ argc : CLong, _ argv : UnsafeMutablePointer<t_atom>?) {
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    let p = obj.pointee.box
    if (p == nil) { return  }
    
    let dispatcher = Box.fromRaw(p!, DispatcherClass.self)
    
    if (s == nil) { return }
    guard let symbol = s?.pointee.s_name else  { return }
    
    let object = dispatcher.takeUnretainedValue().value
    
    let sSymbol = String(cString:symbol)
    
    if object.onSelector.keys.contains(sSymbol) {
//        MaxRuntime.post("perform: \(sSymbol)")
        guard let fn = object.onSelector[sSymbol] else { return }
        
        let atoms = atomsFromPointer(argc, argv)
        let maxList = atoms.asMaxList
        
        fn(maxList)
        return
    }
    
    // list
    
    MaxRuntime.post("perform list")
    
    let atoms = atomsFromPointer(argc, argv)
    let maxList = atoms.asMaxList
    
    object.onList (maxList)
    
    
//    dispatcher.takeUnretainedValue().value.onDouble(value)
    
    return
}
