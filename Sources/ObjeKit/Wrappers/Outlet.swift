//
//  IO.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

// NB: statless wrapper
@propertyWrapper
public struct MaxOutput: MaxIOComponent {
    public var onChange: ((MaxList) -> Void)? // to be provided by AttachInstance
    
    public class Sender {
        var action : (()->Void)?
        public func bang() {
            self.action?()
        }
        
        
    }
    
    public let index: PortIndex
    public var wrappedValue: Sender

    public init(_ outlet: PortIndex = .index(0)) {
        self.index = outlet
        

        self.wrappedValue = Sender()
        
        

        
    }

    public func accept<V: MaxIOVisitor>(visitor: V) {
        visitor.visit(self)
        self.wrappedValue.action = {
            self.onChange?([])
        }
        
    }
}

public class Outlet<T>: MaxIOComponent {    
    public let kind: PortKind = .list
    public var index: PortIndex = .index(0)
    
    private var binding: MaxBinding<T>

    public var onChange: ((T) -> Void)? // to be provided by AttachInstance
    
    public var wrappedValue: T {
        get { binding.get() }
        set { binding.set(newValue) }
    }

    // Init with index and a binding provider closure
    public init(_ outlet: PortIndex = .index(0), _ bindingProvider: @escaping () -> MaxBinding<T>) {
        self.index = outlet
        self.binding = bindingProvider()
        
        self.binding.observe { newValue in
            self.onChange?(newValue)
        }
    }
    
    public init( bindingProvider: @escaping () -> MaxBinding<T>) {
        self.index = .index(0)
        self.binding = bindingProvider()
        
        self.binding.observe { newValue in
            self.onChange?(newValue)
        }
    }
    
//    public init(bindingProvider: @escaping () -> Void) {
//        self.index = .index(0)
//        self.binding = {
//            MaxBinding<T>(
//                get: { T() },
//                set: { _ in },
//                observe: { callback in
//                   
//                }
//            )
//        }()
//    }

    public func accept<V>(visitor: V) where V: MaxIOVisitor {
        visitor.visit(self)
    }
}
