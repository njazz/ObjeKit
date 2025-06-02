//
//  AttachClass.swift
//  ObjeKit
//
//  Created by alex on 02/06/2025.
//

@_implementationOnly import MSDKBridge

class AttachClass : MaxClassIOVisitor {
    var object : UnsafeMutablePointer<t_class>
    
    init(object: UnsafeMutablePointer<t_class>) {
        self.object = object
    }
    
    func visit<T>(_ argument: Argument<T>) {
        
    }
    
    func visit<T>(_ argument: Attribute<T>) {
        
    }
}
