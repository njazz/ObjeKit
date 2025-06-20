//
//  DummyIO.swift
//  ObjeKit
//
//  Created by alex on 20/06/2025.
//


import XCTest
@testable import ObjeKit

import XCTest

// MARK: - Mocks

final class DummyIO: MaxIOComponent {}

final class DummyMaxObject: MaxObject {
    static var className: String { "Dummy" }

    var io: MaxIOComponent { DummyIO() }
    var objects: MaxObject { CompositeMaxObject() }

    required init() {}
}

final class VisitorMock: MaxIOVisitor {
    func visit(_ method: ObjeKit.Inlet) {
        
    }
    
    func visit<T>(_ outlet: ObjeKit.Outlet<T>) {
        
    }
}

final class ClassVisitorMock: MaxClassIOVisitor {
    var visited = 0
}

final class VisitableIO: MaxIOComponent {
    func accept<V: MaxIOVisitor>(visitor: V) {}

    func accept<V: MaxClassIOVisitor>(visitor: V) {
        if let visitorMock = visitor as? ClassVisitorMock {
            visitorMock.visited += 1
        }
    }
}

// MARK: - Tests

final class CompositeMaxTests: XCTestCase {

    func testCompositeMaxObject_DefaultInit() {
        let composite = CompositeMaxObject()
        XCTAssertEqual(composite.objects.objects is CompositeMaxObject, true)
        XCTAssertTrue(composite.components is [ObjeKit.MaxObject])
    }

    func testCompositeMaxObject_WithChildren() {
        let child1 = DummyMaxObject()
        let child2 = DummyMaxObject()
        let composite = CompositeMaxObject([child1, child2])

        let io = composite.io
        XCTAssertTrue(io is CompositeMaxIO)
        let casted = io as! CompositeMaxIO
        XCTAssertEqual(casted.components.count, 2)
    }

    func testCompositeMaxIO_DefaultInit() {
        let io = CompositeMaxIO([])
        XCTAssertEqual(io.components.count, 0)
    }

    func testCompositeMaxIO_WithIO() {
        let io1 = VisitableIO()
        let io2 = VisitableIO()
        let compositeIO = CompositeMaxIO([io1, io2])
        XCTAssertEqual(compositeIO.components.count, 2)
    }

    func testCompositeMaxIO_VisitorAcceptance() {
        let io1 = VisitableIO()
        let io2 = VisitableIO()
        let composite = CompositeMaxIO([io1, io2])
        let visitor = ClassVisitorMock()
        composite.accept(visitor: visitor)
        XCTAssertEqual(visitor.visited, 2)
    }
}

