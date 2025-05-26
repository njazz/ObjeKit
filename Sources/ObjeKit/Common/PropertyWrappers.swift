//
//  Inlet.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//


@propertyWrapper
public struct Inlet<T>: MaxIOComponent {
    var index : UInt8?  // append new if nil
    public var wrappedValue: T
    public init(wrappedValue: T, _ index: UInt8? = nil) {
        self.wrappedValue = wrappedValue
    }
    
    public func accept<V>(visitor: V) where V : MaxIOVisitor {
        visitor.visit(self)
    }
}

// MARK: -
//
//@propertyWrapper
//public struct Outlet<T>: MaxIOComponent {
//    var index : UInt8?  // append new if nil
//    
//    var value : T?
//    
//    public var wrappedValue: T {
//        set { value = newValue}
//        get { value! }
//    }
//    
//    public init(_ index: UInt8?, _ get: () -> T ) {
//        self.index = index
//        self.value = get()
//    }
//    
//    public func accept<V>(visitor: V) where V : MaxIOVisitor {
//        visitor.visit(self)
//    }
//}

@propertyWrapper
public class Outlet<T>: MaxIOComponent {
    var index: UInt8?  // append new if nil
    private var binding: MaxBinding<T>

    public var onChange: ((T) -> Void)?
    
    public var wrappedValue: T {
        get { binding.get() }
        set { binding.set(newValue) }
    }

    // Regular init with a wrapped value
//    public init(wrappedValue: T) {
//        self.index = nil
//        self.binding = MaxBinding(
//            get: { wrappedValue },
//            set: { _ in },
//            observe: { _ in }
//        )
//    }

    // Init with index and a binding provider closure
    public init(_ index: UInt8? = nil, _ bindingProvider: @escaping () -> MaxBinding<T>) {
        self.index = index
        self.binding = bindingProvider()
        
        self.binding.observe { newValue in
            self.onChange?(newValue)
        }
    }
    
    public init( bindingProvider: @escaping () -> MaxBinding<T>) {
        self.index = nil
        self.binding = bindingProvider()
        
        self.binding.observe { newValue in
            self.onChange?(newValue)
        }
    }

    public func accept<V>(visitor: V) where V: MaxIOVisitor {
        visitor.visit(self)
    }
}

//@propertyWrapper
//public class Outlet<T>: MaxIOComponent {
//    var index: UInt8?  // append new if nil
//
//    private let binding: MaxBinding<T>
//    private var observationCancellable: (() -> Void)?  // optional cancellation handler if needed
//
//    // Your callback closure called on each new binding value
//    public var onChange: ((T) -> Void)?
//
//    public var wrappedValue: T {
//        get { binding.get() }
//        set { binding.set(newValue) }
//    }
//
//    public init(_ index: UInt8?, _ binding: MaxBinding<T>, onChange: ((T) -> Void)? = nil) {
//        self.index = index
//        self.binding = binding
//        self.onChange = onChange
//        
//        // Subscribe to binding changes
//        self.binding.observe { newValue in
//            onChange?(newValue)
//        }
//    }
//
//    // Convenience init for concrete value - no observation possible
//    public init(_ index: UInt8?, wrappedValue: T) {
//        self.index = index
//        self.binding = MaxBinding(
//            get: { wrappedValue },
//            set: { _ in },
//            observe: { _ in }
//        )
//        self.onChange = nil
//    }
//
//    public func accept<V>(visitor: V) where V: MaxIOVisitor {
//        visitor.visit(self)
//    }
//}



// MARK: -

@propertyWrapper
public struct MaxBinding<T> : MaxIOComponent {
    
    public var wrappedValue: T {
        get { get() }
        set { set(newValue) }
      }
        
     public let get: () -> T
     public let set: (T) -> Void
     public let observe: (@escaping (T) -> Void) -> Void  // Add this

     public func callAsFunction(_ newValue: T) {
         set(newValue)
     }
    
    public init( get: @escaping () -> T, set: @escaping (T) -> Void, observe: @escaping (@escaping (T) -> Void) -> Void) {
        self.get = get
        self.set = set
        self.observe = observe
    }
 }
 
// MARK: -

 @propertyWrapper
 public class MaxState<T> : MaxIOComponent  {
     private var value: T
     private var observers: [(T) -> Void] = []

     public var wrappedValue: T {
         get { value }
         set {
             value = newValue
             notifyObservers()
         }
     }

     public var projectedValue: MaxBinding<T> {
         MaxBinding(
             get: { self.value },
             set: { self.wrappedValue = $0 },
             observe: { callback in
                 self.observers.append(callback)
                 callback(self.value) // optional: emit initial value
             }
         )
     }

     public init(wrappedValue: T) {
         self.value = wrappedValue
     }

     private func notifyObservers() {
         for obs in observers {
             obs(value)
         }
     }
 }

// MARK: -

// Attribute

// Argument - read only / with requirements

// AudioIn / AudioOut - Buffer wrap

// expand?
// MatrixIn / MatrixOut
// textureIn / TextureOut
