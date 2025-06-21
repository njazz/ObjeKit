//
//  DispatcherClass.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//
@_implementationOnly import MSDKBridge

struct ArgumentData {
    var untypedSetter : (MaxValue)->Bool    /// returns false if fails type conversion
    var optional : Bool
    var description : String?
}

struct AttributeData {
    var description : String?
}

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
    var arguments : [ArgumentData] = []
    var requiredArguments : UInt = 0
    
    var inlets : [UnsafeMutableRawPointer] = []
    var outlets : [UnsafeMutableRawPointer] = []
    
    var attributes : [AttributeData] = []
}

// TODO: use
struct DispatcherClassMetadata {
    var maxClass: UnsafeMutablePointer<t_class>
    var objectType : MaxObject.Type
    
    var inletCount : UInt8
    var outletCount : UInt8
}
