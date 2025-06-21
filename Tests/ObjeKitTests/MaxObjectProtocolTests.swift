//
//  MaxObjectProtocolTests.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 20/06/2025.
//


import XCTest
@testable import ObjeKit

final class MaxObjectProtocolTests: XCTestCase {
    
    class DummyObject: MaxObject {
        required init() {
            
        }
        static var className: String = "DummyObject"
        
        // Not overriding default 'objects' and 'io'
    }
    
    func testDefaultObjectsPropertyReturnsCompositeMaxObject() {
        let obj = DummyObject()
        XCTAssertTrue(type(of: obj.objects) == ObjeKit.CompositeMaxObject.self)
    }
    
    func testDefaultIOPropertyReturnsCompositeMaxIO() {
        let obj = DummyObject()
        let io = obj.io
        XCTAssertTrue(type(of: obj.io) == ObjeKit.CompositeMaxIO.self)
    }
}

final class MaxIOComponentProtocolTests: XCTestCase {
    
    class DummyIOComponent: MaxIOComponent {
        // Uses default accept implementations
    }
    
    struct DummyVisitor: MaxIOVisitor {
        func visit(_ method: ObjeKit.Inlet) {
            
        }
        
        func visit<T>(_ outlet: ObjeKit.Outlet<T>) {
            
        }
    }
    struct DummyClassVisitor: MaxClassIOVisitor {}

    func testDefaultAcceptDoesNotCrash() {
        let io = DummyIOComponent()
        let visitor = DummyVisitor()
        let classVisitor = DummyClassVisitor()
        
        // Should not crash, no observable effect
        io.accept(visitor: visitor)
        io.accept(visitor: classVisitor)
    }
}
