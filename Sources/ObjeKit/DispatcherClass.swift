//
//  DispatcherClass.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//
@_implementationOnly import MSDKBridge

/// Proxy class forwarding to swift object
class DispatcherClass: Initializable {
    required init() {}
    
    var object: MaxObject?
    
    var onBang : ()->Void = {}
    var onDouble : (Double)->Void = {_ in}
    var onInt : (CLong)->Void = {_ in}
    var onSelector : [String : ([MaxValue])->Void] = [:]
    var onList : ([MaxValue])->Void = {_ in}
    
    // 
    var arguments : [(MaxValue)->Void] = []
    var requiredArguments : UInt = 0
}

struct DispatcherClassMetadata {
    var maxClass: UnsafeMutablePointer<t_class>
    var objectType : MaxObject.Type
    
    var inletCount : UInt8
    var outletCount : UInt8
}
