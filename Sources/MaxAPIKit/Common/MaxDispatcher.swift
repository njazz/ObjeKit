//
//  MaxObjectProtocol.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//


// import MaxSDKBridge

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
