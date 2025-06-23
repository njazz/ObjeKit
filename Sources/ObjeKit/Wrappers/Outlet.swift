//
//  IO.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//

/// Max Outlet property wrapper
///
/// NB: this is a stateless shortcut for each outlet to output data directly
/// TODO: currently N/A
@propertyWrapper
public struct MaxOutput: MaxIOComponent {
    public var onChange: ((MaxList) -> Void)? // to be provided by AttachInstance

    /// Sender class for Outlet - use it to send different data
    ///
    /// TODO: yet N/A
    public class Sender {
        var action: (() -> Void)?
        public func bang() {
            action?()
        }
    }

    public let index: PortIndex
    public var wrappedValue: Sender

    public init(_ outlet: PortIndex = .index(0)) {
        index = outlet
        wrappedValue = Sender()
    }

    public func accept<V: MaxIOVisitor>(visitor: V) {
        visitor.visit(self)
        wrappedValue.action = {
            self.onChange?([])
        }
    }
}

// MARK: -

/// Max Outlet component
///
/// NB default is always inlet 0
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
        index = outlet
        binding = bindingProvider()

        binding.observe { newValue in
            self.onChange?(newValue)
        }
    }

    public init(bindingProvider: @escaping () -> MaxBinding<T>) {
        index = .index(0)
        binding = bindingProvider()

        binding.observe { newValue in
            self.onChange?(newValue)
        }
    }
    
    public init(_ outlet: PortIndex = .index(0), name: String, _ _ bindingProvider: @escaping () -> MaxBinding<T>) {
        index = outlet
        binding = bindingProvider()
        kind = .selector(name)

        binding.observe { newValue in
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
