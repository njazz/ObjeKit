//
//  MaxIOVisitorTests.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 20/06/2025.
//


import XCTest
@testable import ObjeKit

final class MaxIOVisitorTests: XCTestCase {
    
    // A dummy concrete type without overriding default methods
    struct DefaultVisitor: MaxIOVisitor {
        func visit(_ method: ObjeKit.Inlet) {
            
        }
        
        func visit<T>(_ outlet: ObjeKit.Outlet<T>) {
            
        }
    }

    // A concrete type that overrides visit methods
    class CustomVisitor: MaxIOVisitor {
        func visit(_ method: ObjeKit.Inlet) {
            
        }
        
        func visit<T>(_ outlet: ObjeKit.Outlet<T>) {
            
        }
        
        var visitedOutlets = 0
        var visitedArguments = 0
        
        func visit(_ outlet: MaxOutput) {
            visitedOutlets += 1
        }
        
        func visit<T>(_ argument: Argument<T>) -> Bool {
            visitedArguments += 1
            return false
        }
    }

    func testDefaultVisitorDoesNothing() {
        let visitor = DefaultVisitor()
        
        // Calls should not crash and default returns apply
        visitor.visit(MaxOutput())
        let result = visitor.visit(Argument<Int>())
        
        XCTAssertTrue(result, "Default visit(Argument) should return true")
    }
    
    func testCustomVisitorOverridesCalled() {
        let visitor = CustomVisitor()
        
        visitor.visit(MaxOutput())
        let result = visitor.visit(Argument<Int>())
        
        XCTAssertEqual(visitor.visitedOutlets, 1, "Custom visit(_ outlet:) should increment visitedOutlets")
        XCTAssertEqual(visitor.visitedArguments, 1, "Custom visit(Argument) should increment visitedArguments")
        XCTAssertFalse(result, "Custom visit(Argument) returns false")
    }
}

final class MaxClassIOVisitorTests: XCTestCase {
    
    struct DefaultVisitor: MaxClassIOVisitor {}
    
    class CustomVisitor: MaxClassIOVisitor {
        var visitedAttributes = 0
        
        func visit<T>(_ attribute: Attribute<T>) {
            visitedAttributes += 1
        }
    }
    
    func testDefaultVisitorDoesNothing() {
        let visitor = DefaultVisitor()
        
        let b1 = MaxBinding(get: {0}, set: {_ in }) { _ in
            
        }
        
        visitor.visit(Attribute<Int>({b1}))
        // No crash and no effect to assert
    }
    
    func testCustomVisitorOverridesCalled() {
        let visitor = CustomVisitor()
        
        let b1 = MaxBinding(get: {0}, set: {_ in }) { _ in
            
        }
        
        visitor.visit(Attribute<Int>({b1}))
        XCTAssertEqual(visitor.visitedAttributes, 1)
    }
}
