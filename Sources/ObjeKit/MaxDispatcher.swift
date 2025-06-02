//
//  MaxObjectProtocol.swift
//  ObjeKit
//
//  Created by alex on 25/05/2025.
//

@_implementationOnly import MSDKBridge

/// Dynamically dispatching max object
public class MaxDispatcher {
    // TODO: ctor -> ID
    static var _metadata: [String: DispatcherClassMetadata] = [:]

    // TODO: use metadata:
    static var _classMap: [String: UnsafeMutablePointer<t_class>] = [:]
    static var _swiftClassMap: [String: MaxObject.Type] = [:]

    /// public setup function to be exported
    public static func setup<T: MaxObject>(_ t : T.Type) {
        let s = T.className
        
        guard let current_ctor : method = get_next_ctor(_ctor) else {
            MaxRuntime.post ("Dispatch error")
            return
        }
        
        let ctor_ptr = unsafeBitCast(current_ctor, to: UnsafeRawPointer.self)
        
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

        MaxDispatcher._classMap["\(ctor_ptr)"] = _class
        MaxDispatcher._swiftClassMap["\(ctor_ptr)"] = t

        class_register(class_box(), _class)
    }
}

