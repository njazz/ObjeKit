//
//  MaxObject.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//

@_implementationOnly import MaxSDKBridge

public protocol Initializable {
    init()
}

// MARK: ---

public protocol MaxObject : AnyObject , Initializable {
    static var className : String { get }
    
    init()
    
//    static func _initObject(_ ptr: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
    
//  func process()
//
//  func cleanup()
}




//
//@propertyWrapper
//struct Ctor<T : MaxObject> {
//    var wrappedValue: @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
//        return { _ in
//            let instance = T()
//            let unmanaged = Unmanaged.passRetained(Box(instance))
//            return UnsafeMutableRawPointer(unmanaged.toOpaque())
//        }
//    }
//}
//
//@propertyWrapper
//struct Dtor<T: MaxObject> {
//    var wrappedValue: @convention(c) (UnsafeMutableRawPointer?) -> Void {
//        return { ptr in
//            guard let ptr else { return }
//            Unmanaged<Box<T>>.fromOpaque(ptr).release()
//        }
//    }
//}


