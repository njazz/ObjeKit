//
//  Inlet.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//

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
public class MaxState<T:Equatable> : MaxIOComponent  {
     private var value: T
     private var observers: [(T) -> Void] = []

     public var wrappedValue: T {
         get { value }
         set {
             if value != newValue {
                 value = newValue
                 notifyObservers()
             }
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


