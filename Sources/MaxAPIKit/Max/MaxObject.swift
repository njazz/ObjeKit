//
//  MaxObject.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//



// MARK: ---

public protocol MaxObject : AnyObject {
//    var className : String { get }
    init()
    
//    static func _initObject(_ ptr: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
    
  func process()

  func cleanup()
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

public class Box<T : MaxObject> {
    let value: T

    public init(_ value: T) {
        self.value = value
    }

    public static func create(_ type: T.Type) -> Box<T> {
       Box(T())
    }

    public func toRaw() -> UnsafeMutableRawPointer {
        return Unmanaged.passRetained(self).toOpaque()
    }

    public static func fromRaw(_ ptr: UnsafeMutableRawPointer, _ type: T.Type) -> Unmanaged<Box<T>> {
        return Unmanaged<Box<T>>.fromOpaque(ptr)
    }

    func release() {
        Unmanaged.passUnretained(self).release()
    }
}
