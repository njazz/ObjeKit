//
//  MaxObjectProtocol.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//

@_implementationOnly import MaxSDKBridge

func _ctor(_ p: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    MaxRuntime.post ("input pointer: \(p)")
    let ctor_ptr = unsafeBitCast(p, to: UnsafeRawPointer.self)
    
//    let index = Int(bitPattern: p)
    
    let cls = MaxDispatcher._classMap["\(ctor_ptr)"]
    
    if (cls == nil){
        MaxRuntime.post ("class error: \(ctor_ptr)")
    }
    
    let obj = object_alloc(cls)
    if (obj==nil) { return nil }
        
    let typed_obj = obj!.assumingMemoryBound(to: t_wrapped_object.self) // as! UnsafeMutablePointer<t_wrapped_object>?
    
//    MaxRuntime.post ("object pointer: \(obj)")
    
//    for className in MaxDispatcher._classMap.keys {
//
//        let sym = gensym(className)
//        if object_classname_compare(obj, sym) == Int(1) {
//            if let swiftClass = MaxDispatcher._swiftClassMap[className] {
//                let box = Box.create(DispatcherClass.self)
//                box.value.object = swiftClass.init()
//                obj.pointee._ptr = box.toRaw()
//            }
//            break
//        }
//    }
//
//    return nil
    if let swiftClass = MaxDispatcher._swiftClassMap["\(ctor_ptr)"] {
        let box = Box.create(DispatcherClass.self)
        box.value.object = swiftClass.init()
        typed_obj.pointee._ptr = box.toRaw()
    }
    
    
    return obj// as! UnsafeMutableRawPointer?
}

func _dtor(ptr: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    if (ptr==nil) { return nil }
    
    let obj = ptr!.assumingMemoryBound(to: t_wrapped_object.self)
    let p = obj.pointee._ptr

    if p != nil { Box.fromRaw(p!, DispatcherClass.self).release() }
    return nil
}

struct DispatcherClass: Initializable {
    var object: MaxObject?
    init() {}
}

// MARK: -

public class MaxDispatcher {
//    static var _class: UnsafeMutablePointer<t_class>?

    static var _classMap: [String: UnsafeMutablePointer<t_class>] = [:]
    static var _swiftClassMap: [String: MaxObject.Type] = [:]

    public static func setup<T: MaxObject>(_ t : T.Type) {
        let s = T.className
//        let t = T.Type
        
        guard let current_ctor : method = get_next_ctor(_ctor) else {
            MaxRuntime.post ("Dispatch error")
            return
        }
        
        let c_ctor : @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? = _ctor
        
        let ctor_ptr = unsafeBitCast(current_ctor, to: UnsafeRawPointer.self)
        MaxRuntime.post ("current ctor: \(unsafeBitCast(current_ctor, to: UnsafeRawPointer.self)) ctor: \(unsafeBitCast(c_ctor, to: UnsafeRawPointer.self))")
        
        current_ctor(nil)
        
//        return
        
        let _class = _class_new_basic(s,
                                      current_ctor,
                                      _dtor,
                                      t_wrapped_object_size())

        if _class == nil { return }

//        MaxDispatcher._class = _class
        
        MaxRuntime.post ("class pointer: \(_class) for \(s) | ctor: \(current_ctor)")

        MaxDispatcher._classMap["\(ctor_ptr)"] = _class
        MaxDispatcher._swiftClassMap["\(ctor_ptr)"] = t

        class_register(class_box(), _class)
    }
}

/*

 // Dispatcher that handles registration, instance creation and dispatching
 public class MaxDispatcher {
     // Map from Max t_class* pointer to Swift type
     static var typeForClassPtr: [UnsafeMutablePointer<t_class>: MaxObject.Type] = [:]

     // Map from class pointer to constructor and destructor closures
     static var ctorForClassPtr: [UnsafeMutablePointer<t_class>: @convention(c) () -> UnsafeMutableRawPointer?] = [:]
     static var dtorForClassPtr: [UnsafeMutablePointer<t_class>: @convention(c) (UnsafeMutableRawPointer?) -> Void] = [:]

     // Map from instance pointer to Swift instance (retained)
     static var instances: [UnsafeMutableRawPointer: MaxObject] = [:]

     /// Register a new Max class
     public static func register<T: MaxObject>(
         name: String,
         type: T.Type,
         ctor: @convention(c) () -> UnsafeMutableRawPointer?,
         dtor: @convention(c) (UnsafeMutableRawPointer?) -> Void
     ) {
         let cName = strdup(name)

         // Create Max class with initializer callback
         let classPtr = _class_new_basic(
             cName,
             { (classRawPtr) -> UnsafeMutableRawPointer? in
                 // classRawPtr is the Max class pointer
                 return MaxDispatcher.initObject(classPtr: classRawPtr)
             },
             nil,
             MemoryLayout<UnsafeMutableRawPointer>.size
         )
         guard let cls = classPtr else {
             fatalError("Failed to create Max class")
         }

         // Store Swift type for this class pointer
         typeForClassPtr[cls] = type

         // Store ctor and dtor closures
         ctorForClassPtr[cls] = ctor
         dtorForClassPtr[cls] = dtor

         // Register class in Max runtime
         class_register(gensym(name), cls)

         free(cName)
     }

     /// Called by Max to create a new instance
     static func initObject(classPtr: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
         guard let classPtr = classPtr else { return nil }

         // Cast to t_class pointer
         let clsPtr = UnsafeMutablePointer<t_class>(classPtr.assumingMemoryBound(to: t_class.self))

         // Lookup stored ctor closure for this class
         guard let ctor = ctorForClassPtr[clsPtr] else {
             print("MaxDispatcher: no ctor found for class pointer")
             return nil
         }

         // Call user-provided ctor closure to get instance pointer
         guard let instancePtr = ctor() else {
             print("MaxDispatcher: ctor returned nil instance pointer")
             return nil
         }

         // Retain instance in instances map — since ctor returns UnsafeMutableRawPointer,
         // we need to bridge to Swift instance for tracking and release
         // Let's assume the instance is a Swift class conforming to MaxObject and
         // that the ctor returns pointer to a retained instance of it
         // So we can reconstruct the instance from the pointer:
         let instance = ctorForClassPtr[clsPtr]!() //Unmanaged<MaxObject>.fromOpaque(instancePtr).takeUnretainedValue()

         instances[instancePtr] = instance

         return instancePtr
     }

     /// Release and remove instance
     public static func free(_ instancePtr: UnsafeMutableRawPointer?) {
         guard let ptr = instancePtr else { return }

         // Find instance in dictionary
         guard let instance = instances.removeValue(forKey: ptr) else {
             print("MaxDispatcher: free called for unknown instance pointer")
             return
         }

         // Find class pointer for the instance - we need a way to get class pointer from instance
         // But since we only have the instance pointer, let's try to get the class pointer from the instance

         // If MaxObject has a property or method that returns the class pointer, use that.
         // Otherwise, consider storing a reverse map instancePtr -> classPtr when creating instance.

         // For now, we store instancePtr->classPtr map (add this dictionary)
         guard let classPtr = classForInstancePtr[ptr] else {
             print("MaxDispatcher: no class pointer found for instance, cannot call dtor")
             return
         }

         // Call stored dtor closure
         guard let dtor = dtorForClassPtr[classPtr] else {
             print("MaxDispatcher: no dtor found for class pointer")
             return
         }

         // Call destructor closure with instance pointer
         dtor(ptr)

         // Release the retained Swift instance to balance passRetained done by ctor
         Unmanaged.passUnretained(instance).release()

         // Remove the reverse mapping
         classForInstancePtr.removeValue(forKey: ptr)
     }

     // Map instance pointer to class pointer for reverse lookup on free
     static var classForInstancePtr: [UnsafeMutableRawPointer: UnsafeMutablePointer<t_class>] = [:]
 }

 */
