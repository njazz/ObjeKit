//
//  MaxObject.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//

@_implementationOnly import MaxSDKBridge

public protocol Initializable {
    init()
}

// MARK: -

public protocol MaxObject : AnyObject , Initializable {
    static var className : String { get }
    
    // var object: MaxObject { get }
}

public protocol MaxComponent : AnyObject, Initializable {
    var children: [MaxComponent] { get }
}
