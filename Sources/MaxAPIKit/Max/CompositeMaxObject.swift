//
//  CompositeMaxObject.swift
//  MaxAPIKit
//
//  Created by alex on 26/05/2025.
//


public class CompositeMaxObject: MaxObject {
    public static var className: String { "Composite" }
    
    let children: [MaxObject]

    public required init(){
        self.children = []
    }
    
    public init(_ children: [MaxObject] = []) {
        self.children = children
    }

    public func performAction() {
        for child in children {
//            child.performAction()
        }
    }
}
