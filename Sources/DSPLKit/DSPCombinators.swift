//
//  Parallel.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//


public struct Parallel: DSPObject {
    public var build: any DSPObject
    
//    public static func build() -> any DSPObject {
//        
//    }
    
    public var configuration: DSPConfiguration
    
    var left: DSPObject
    var right: DSPObject
    
    public func process() {
        left.process()
        right.process()
    }
}

public struct Sequential: DSPObject {
    public var build: any DSPObject
    
//    public static func build() -> any DSPObject {
//        
//    }
    
    public var configuration: DSPConfiguration
    
    var first: DSPObject
    var second: DSPObject
    
    public func process() {
        first.process()
        second.process()
    }
}

// MARK: -

// E.g. feedback using ~ could be added as a circular buffer wrapper

public final class ParallelDSP: DSPInspectable {
    private let nodes: [DSPInspectable]

    public init(@DSPBuilder _ content: () -> [DSPInspectable]) {
        self.nodes = content()
        
        // TODO: connections
    }

    public func process() {
//        for node in nodes {
//            (node as? DSPNode)?.process()
//        }
    }

    public var allInputs: [UnsafePointer<Float>] {
        nodes.flatMap { $0.allInputs }
    }

    public var allOutputs: [UnsafeMutablePointer<Float>] {
        nodes.flatMap { $0.allOutputs }
    }
}
