//
//  MaxRuntime.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//

@_implementationOnly import MaxSDKBridge

public enum MaxRuntime {
    public static func register<T>(name: String, _ type: T.Type) {
        let cName = name.withCString { strdup($0)
        }
        
        let _class =
        _class_new_basic(
            cName,
//            { (x, argc, argv) -> UnsafeMutableRawPointer? in
//                let args = (0..<Int(argc)).map { i in
//                    Atom(argv[i])
//                }
//                let instance = T(args: args)
//                let unmanaged = Unmanaged.passRetained(Box(instance))
//                return UnsafeMutableRawPointer(unmanaged.toOpaque())
//            },
            { _ in nil},
            
            nil,
            MemoryLayout<Box<T>>.size//,
//            nil,
//            Int16(A_GIMME.rawValue),
//            0
        )

        //class_addmethod(cName, unsafeBitCast(bangThunk<T>, to: method.self), "bang", "i", 0)

        class_register(gensym("box"), _class)
    }

//    static func bangThunk<T: MaxObject>(_ selfPtr: UnsafeMutableRawPointer, _ inlet: Int32) {
//        let box = Unmanaged<Box<T>>.fromOpaque(selfPtr).takeUnretainedValue()
//        box.value.bang(inlet: inlet)
//    }

    final class Box<T> {
        let value: T
        init(_ value: T) { self.value = value }
    }
    
    // MARK: -
    public static func post(_ text: String) {
        poststring(UnsafeMutablePointer<CChar>(mutating: text))
    }
}
