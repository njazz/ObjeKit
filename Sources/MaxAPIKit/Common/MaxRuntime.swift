//
//  MaxRuntime.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//

@_implementationOnly import MaxSDKBridge

public enum MaxRuntime {
    struct _Methods<T: MaxObject> {
        static func _initializer(_ ptr: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
            let instance = T()
            let unmanaged = Unmanaged.passRetained(Box(instance))
            return UnsafeMutableRawPointer(unmanaged.toOpaque())
        }
    }

    public static func register<T: MaxObject>(name: String,
                                              ctor: @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?,
                                              dtor: @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?,
                                              _ : T.Type
    ) {
        let cName = name.withCString { strdup($0)
        }

        let _class =
            _class_new_basic(
                cName,
                ctor,
                dtor,
//                MaxDispatcher.initObject,
//                MaxDispatcher.free,
                
                MemoryLayout<Box<T>>.size
            )

        // class_addmethod(cName, unsafeBitCast(bangThunk<T>, to: method.self), "bang", "i", 0)

        class_register(gensym("box"), _class)
    }

//    static func bangThunk<T: MaxObject>(_ selfPtr: UnsafeMutableRawPointer, _ inlet: Int32) {
//        let box = Unmanaged<Box<T>>.fromOpaque(selfPtr).takeUnretainedValue()
//        box.value.bang(inlet: inlet)
//    }

    

    // MARK: -

    public static func post(_ text: String) {
        poststring(UnsafeMutablePointer<CChar>(mutating: text))
    }
}
