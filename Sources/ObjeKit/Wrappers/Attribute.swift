//
//  Untitled.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

@propertyWrapper
public class Attribute<T>: MaxIOComponent {
    var index: UInt8?  // append new if nil
    private var binding: MaxBinding<T>

    public var onChange: ((T) -> Void)?
    
    public var wrappedValue: T {
        get { binding.get() }
        set { binding.set(newValue) }
    }

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

    public func accept<V>(visitor: V) where V: MaxClassIOVisitor {
        visitor.visit(self)
    }
}
