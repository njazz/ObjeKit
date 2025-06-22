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
        MaxLogger.shared.post("Register Attribute: \(attribute.name) \(attribute.label ?? "No label") \(attribute.style) transitional:\(attribute.transitional)")

        func commonSetup() {
            _class_attr_accessors(object, attribute.name, _dispatch_attr_getter , _dispatch_attr_setter )
            _class_attr_save(object, attribute.name, !attribute.transitional)
            if attribute.label != nil {
                _class_attr_label(object, attribute.name, attribute.label!)
            }
        }

        if T.Type.self == CLong.Type.self {
            _class_add_attr_long(object, attribute.name)
            commonSetup()
        }

        if T.Type.self == Double.Type.self {
            _class_add_attr_double(object, attribute.name)
            commonSetup()
        }

        if T.Type.self == String.Type.self {
            _class_add_attr_symbol(object, attribute.name)
            commonSetup()
        }
    }
}
