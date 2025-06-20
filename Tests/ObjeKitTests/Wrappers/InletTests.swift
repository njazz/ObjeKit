//
//  InletTests.swift
//  ObjeKit
//
//  Created by alex on 20/06/2025.
//

import XCTest
@testable import ObjeKit

struct MaxValueTest: Equatable {
    let intValue: Int
    init(_ value: Int) { self.intValue = value }
}

final class TestVisitor: MaxIOVisitor {
    func visit<T>(_ outlet: ObjeKit.Outlet<T>) {
        
    }
    
    var didVisit = false
    func visit(_ inlet: Inlet) {
        didVisit = true
    }
}


// MARK: -

final class InletTests: XCTestCase {

    func testBangInlet_callsClosure() {
        var called = false
        let inlet = Inlet {
            called = true
        }

        XCTAssertEqual(inlet.kind, .bang)
//        XCTAssertEqual(inlet.index, .index(0))
        inlet.callAsBang()
        XCTAssertTrue(called)
    }

    func testFloatInlet_callsClosure() {
        var receivedValue: Double?
        let inlet = Inlet { (value: CDouble) in
            receivedValue = value
        }

        XCTAssertEqual(inlet.kind, .float)
        inlet.callAsFloat(3.14)
        XCTAssertEqual(receivedValue, 3.14)
    }

    func testIntInlet_callsClosure() {
        var receivedValue: CLong?
        let inlet = Inlet { (value: CLong) in
            receivedValue = value
        }

        XCTAssertEqual(inlet.kind, .int)
        inlet.callAsInt(42)
        XCTAssertEqual(receivedValue, 42)
    }

//    func testListInlet_callsClosure() {
//        var receivedValues: [MaxValue] = []
//        let inlet = Inlet { (values: [MaxValue]) in
//            receivedValues = values
//        }
//
//        XCTAssertEqual(inlet.kind, .list)
//        let testValues = [MaxValue(1), MaxValue(2)]
//        inlet.callAsSelector(testValues)
//        XCTAssertEqual(receivedValues, testValues)
//    }

//    func testSelectorInlet_callsClosure() {
//        var received: [MaxValue]?
//        let inlet = Inlet(name: "foo") { values in
//            received = values
//        }
//
//        guard case .selector(let name) = inlet.kind else {
//            XCTFail("Expected selector kind")
//            return
//        }
//
//        XCTAssertEqual(name, "foo")
//
//        let args = [MaxValue(9), MaxValue(10)]
//        inlet.callAsSelector(args)
//        XCTAssertEqual(received, args)
//    }

    func testSelectorInlet_withVoidClosure() {
        var called = false
        let inlet = Inlet(name: "bar") {
            called = true
        }

        guard case .selector(let name) = inlet.kind else {
            XCTFail("Expected selector kind")
            return
        }

        XCTAssertEqual(name, "bar")

        // Even though it wraps a void closure, it should be callable as selector
        inlet.callAsSelector([])
        XCTAssertTrue(called)
    }

    func testInlet_customIndex() {
        let inlet = Inlet(.index(3)) { }

//        XCTAssertEqual(inlet.index, .index(3))
    }

    func testInlet_acceptsVisitor() {
        let inlet = Inlet { }
        let visitor = TestVisitor()

        inlet.accept(visitor: visitor)

        XCTAssertTrue(visitor.didVisit)
    }

    func testWrappedValue_preservesFunction() {
        var called = false
        let inlet = Inlet {
            called = true
        }

        let wrapped = inlet.wrappedValue
        (wrapped as? () -> Void)?()
        XCTAssertTrue(called)
    }
}
