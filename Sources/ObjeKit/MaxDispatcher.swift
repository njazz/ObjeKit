//
//  MaxObjectProtocol.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//

@_implementationOnly import MSDKBridge

struct CtorPointer: Hashable {
    let raw: UnsafeRawPointer

    init(_ pointer: UnsafeRawPointer) {
        self.raw = pointer
    }

    // Conform to Hashable using the pointer's address
    func hash(into hasher: inout Hasher) {
        hasher.combine(UInt(bitPattern: raw))
    }

    static func == (lhs: CtorPointer, rhs: CtorPointer) -> Bool {
        return lhs.raw == rhs.raw
    }
}

/// Dynamically dispatching max object
public class MaxDispatcher {
    
    static var _metadata: [CtorPointer: DispatcherClassMetadata] = [:]

    // TODO: use metadata:
//    static var _classMap: [String: UnsafeMutablePointer<t_class>] = [:]
//    static var _swiftClassMap: [String: MaxObject.Type] = [:]

    /// public setup function to be exported
    public static func setup<T: MaxObject>(_ t : T.Type) {
        MaxRuntime.post("*** Setup")
        
        let s = T.className
        
        guard let current_ctor : method_ctor = get_next_ctor(_ctor) else {
            MaxRuntime.post ("Dispatch error")
            return
        }
        
        // let ctor_ptr = unsafeBitCast(current_ctor, to: UnsafeRawPointer.self)
        
        let ctor_ptr_value = CtorPointer(unsafeBitCast(current_ctor, to: UnsafeRawPointer.self))
        
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
        
        MaxDispatcher._metadata[ctor_ptr_value] = DispatcherClassMetadata(maxClass: _class!, objectType: t)
        
        // attributes:
        let _instance = T()
        
        let visitor = AttachClass(object: _class!)

//        let mirror = Mirror(reflecting: _instance)
//
//        // Gather all property wrappers conforming to MaxIOComponent
//        let wrappers = mirror.children.compactMap { child -> MaxIOComponent? in
//            // Property wrappers are stored under _propertyName, or sometimes with $propertyName, so we test both
//            if let component = child.value as? MaxIOComponent {
//                return component
//            }
//            return nil
//        }
//
//        // properties
//        for component in wrappers {
//            MaxRuntime.post("visitor \(visitor) component \(component)")
//            component.accept(visitor: visitor)
//        }
        MaxRuntime.post("visitor \(visitor) instance \(_instance) io \(_instance.io)")
        _instance.io.accept(visitor: visitor)
        
        MaxRuntime.post("Init attr done")
        //

//        MaxDispatcher._classMap["\(ctor_ptr)"] = _class
//        MaxDispatcher._swiftClassMap["\(ctor_ptr)"] = t

        class_register(class_box(), _class)
    }
}

