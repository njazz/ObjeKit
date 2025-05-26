//
//  MaxObjectProtocol.swift
//  ObjeKit
//
//  Created by alex on 25/05/2025.
//

@_implementationOnly import MaxSDKBridge

func _ctor(_ p: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    MaxRuntime.post ("input pointer: \(p)")
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

func _dtor(ptr: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    if (ptr==nil) { return nil }
    
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    
    t_wrapped_object_free_proxy(obj)
    
    let p = obj.pointee.box

    if p != nil { Box.fromRaw(p!, DispatcherClass.self).release() }
    return nil
}

// MARK: -

func _method_bang(_ ptr: UnsafeMutableRawPointer?) -> Void {
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    let p = obj.pointee.box
    if (p == nil) { return  }
    
    let dispatcher = Box.fromRaw(p!, DispatcherClass.self)
    
    dispatcher.takeUnretainedValue().value.onBang()
    
    return
}


func _method_int(_ ptr: UnsafeMutableRawPointer?, _ value: CLong) -> Void {
    
    
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    let p = obj.pointee.box
    if (p == nil) { return  }
    
    let dispatcher = Box.fromRaw(p!, DispatcherClass.self)
    
    dispatcher.takeUnretainedValue().value.onInt(value)
    
    return
}

func _method_float(_ ptr: UnsafeMutableRawPointer?, _ value: CDouble) -> Void {
    
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    let p = obj.pointee.box
    if (p == nil) { return  }
    
    let dispatcher = Box.fromRaw(p!, DispatcherClass.self)
    
    dispatcher.takeUnretainedValue().value.onDouble(value)
    
    return
}

func _method_list(_ ptr: UnsafeMutableRawPointer?, _ s: UnsafeMutablePointer<t_symbol>?, _ argc : CLong, _ argv : UnsafeMutablePointer<t_atom>?) {
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    let p = obj.pointee.box
    if (p == nil) { return  }
    
    let dispatcher = Box.fromRaw(p!, DispatcherClass.self)
    
    if (s == nil) { return }
    guard let symbol = s?.pointee.s_name else  { return }
    
    let object = dispatcher.takeUnretainedValue().value
    
    let sSymbol = String(cString:symbol)
    
    if object.onSelector.keys.contains(sSymbol) {
        MaxRuntime.post("perform: \(sSymbol)")
        guard let fn = object.onSelector[sSymbol] else { return }
        fn([])
        return
    }
    
    // list
    
    MaxRuntime.post("perform list")
    object.onList ([])
    
    
//    dispatcher.takeUnretainedValue().value.onDouble(value)
    
    return
}

// MARK: -

class DispatcherClass: Initializable {
    var object: MaxObject?
    
    required init() {}
    
    var onBang : ()->Void = {}
    var onDouble : (Double)->Void = {_ in}
    var onInt : (CLong)->Void = {_ in}
    var onSelector : [String : ([MaxValue])->Void] = [:]
    var onList : ([MaxValue])->Void = {_ in}
}

// MARK: -

public class MaxDispatcher {
    struct ClassMetadata {
        var maxClass: UnsafeMutablePointer<t_class>
        var objectType : MaxObject.Type
        
        var inletCount : UInt8
        var outletCount : UInt8
    }
    
    static var _metadata: [String: ClassMetadata] = [:]

    static var _classMap: [String: UnsafeMutablePointer<t_class>] = [:]
    static var _swiftClassMap: [String: MaxObject.Type] = [:]
    
    // TODO: ctor -> ID

    public static func setup<T: MaxObject>(_ t : T.Type) {
        let s = T.className
        
        guard let current_ctor : method = get_next_ctor(_ctor) else {
            MaxRuntime.post ("Dispatch error")
            return
        }
        
//        let c_ctor : @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? = _ctor
        let ctor_ptr = unsafeBitCast(current_ctor, to: UnsafeRawPointer.self)
        
//        MaxRuntime.post ("current ctor: \(unsafeBitCast(current_ctor, to: UnsafeRawPointer.self)) ctor: \(unsafeBitCast(c_ctor, to: UnsafeRawPointer.self))")
        
        let _class = _class_new_basic(s,
                                      current_ctor,
                                      _dtor,
                                      t_wrapped_object_size())
        
        _class_add_bang_method(_class, _method_bang, "bang")
        _class_add_int_method(_class, _method_int, "int")
        _class_add_float_method(_class, _method_float, "float")
        _class_add_full_method(_class, _method_list, "anything")
        _class_add_full_method(_class, _method_list, "list")

        if _class == nil {
            MaxRuntime.post("Couldn't initialize class")
            return
        }
        
//        MaxRuntime.post ("class pointer: \(_class) for \(s) | ctor: \(current_ctor)")

        MaxDispatcher._classMap["\(ctor_ptr)"] = _class
        MaxDispatcher._swiftClassMap["\(ctor_ptr)"] = t

        class_register(class_box(), _class)
    }
}

