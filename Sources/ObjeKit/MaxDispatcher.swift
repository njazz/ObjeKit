//
//  MaxObjectProtocol.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//

@_implementationOnly import MSDKBridge

/// Hashable object constructor pointer
struct CtorPointer: Hashable {
    let raw: UnsafeRawPointer

    init(_ pointer: UnsafeRawPointer) {
        raw = pointer
    }

    // Conform to Hashable using the pointer's address
    func hash(into hasher: inout Hasher) {
        hasher.combine(UInt(bitPattern: raw))
    }

    static func == (lhs: CtorPointer, rhs: CtorPointer) -> Bool {
        return lhs.raw == rhs.raw
    }
}

// MARK: -

/// Dynamically dispatching Max object
public class MaxDispatcher {
    static var _metadata: [CtorPointer: DispatcherClassMetadata] = [:]

    /// Public setup function to be exported
    public static func setup<T: MaxObject>(_ t: T.Type) {
        MaxLogger.shared.post("*** Setup")

        let s = T.className

        guard let current_ctor: method_ctor = get_next_ctor(_ctor) else {
            MaxLogger.shared.error("Dispatch error")
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
            MaxLogger.shared.error("Couldn't initialize class")
            return
        }

        MaxDispatcher._metadata[ctor_ptr_value] = DispatcherClassMetadata(maxClass: _class!, objectType: t)

        // attributes:
        let _instance = T()

        let visitor = AttachClass(object: _class!)

        MaxLogger.shared.post("visitor \(visitor) instance \(_instance) io \(_instance.io)")
        _instance.io.accept(visitor: visitor)

        MaxLogger.shared.post("Init attr done")

        class_register(class_box(), _class)
    }
}
