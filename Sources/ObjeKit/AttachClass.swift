//
//  AttachClass.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 02/06/2025.
//

@_implementationOnly import MSDKBridge

/// Connects DispatcherClass with MaxObject Instance 'static' properties
///
/// Currently this is used only for Attribute() elements
class AttachClass: MaxClassIOVisitor {
    var object: UnsafeMutablePointer<t_class>

    init(object: UnsafeMutablePointer<t_class>) {
        self.object = object
    }

    func visit<T>(_ attribute: Attribute<T>) {
        MaxLogger.shared.post("Register Attribute: \(attribute.name) \(attribute.label) \(attribute.style) transitional:\(attribute.transitional)")

        if T.Type.self == CLong.Type.self {
            _class_add_attr_long(object, attribute.name)
        }

        if T.Type.self == Double.Type.self {
            _class_add_attr_double(object, attribute.name)
        }
    }
}
