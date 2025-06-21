//
//  MaxBuilderTests.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 20/06/2025.
//


import XCTest
@testable import ObjeKit

final class MockMaxObject: MaxObject {
    static var className: String { "Mock" }

    required init() {}

    var objects: MaxObject { self }
    var io: MaxIOComponent { MockIOComponent() }
}

final class MockIOComponent: MaxIOComponent {
    func accept<V>(visitor: V) where V : MaxIOVisitor {}
    func accept<V>(visitor: V) where V : MaxClassIOVisitor {}
}

final class CompositeMaxObject: MaxObject {
    static var className: String { "Composite" }

    let components: [MaxObject]

    required init() {
        self.components = []
    }

    init(_ components: [MaxObject]) {
        self.components = components
    }

    var objects: MaxObject { self }
    var io: MaxIOComponent { CompositeMaxIO(components.map { $0.io }) }
}

final class CompositeMaxIO: MaxIOComponent {
    let components: [MaxIOComponent]

    init(_ components: [MaxIOComponent]) {
        self.components = components
    }

    func accept<V>(visitor: V) where V : MaxIOVisitor {}
    func accept<V>(visitor: V) where V : MaxClassIOVisitor {}
}

// MARK: -

final class MaxBuilderTests: XCTestCase {

    func testMaxObjectBuilder_singleComponent_returnsItDirectly() {
        let obj = MockMaxObject()

        let result = MaxObjectBuilder.buildBlock(obj)

        XCTAssertTrue(result === obj, "Expected single object to be returned directly")
    }

    func testMaxObjectBuilder_multipleComponents_returnsComposite() {
        let obj1 = MockMaxObject()
        let obj2 = MockMaxObject()

        let result = MaxObjectBuilder.buildBlock(obj1, obj2)

        guard let composite = result as? ObjeKit.CompositeMaxObject else {
            XCTFail("Expected CompositeMaxObject")
            return
        }

        XCTAssertEqual(composite.objects.count, 2)
        XCTAssertTrue(composite.objects[0] === obj1)
        XCTAssertTrue(composite.objects[1] === obj2)
    }

    func testMaxObjectBuilder_optionalComponent_present_returnsIt() {
        let obj = MockMaxObject()

        let result = MaxObjectBuilder.buildOptional(obj)

        XCTAssertTrue(result === obj, "Expected non-nil optional to be returned")
    }

    func testMaxObjectBuilder_optionalComponent_nil_returnsEmptyComposite() {
        let result = MaxObjectBuilder.buildOptional(nil)

        guard let composite = result as? ObjeKit.CompositeMaxObject else {
            XCTFail("Expected CompositeMaxObject")
            return
        }

        XCTAssertEqual(composite.objects.count, 0)
    }

    func testMaxObjectBuilder_buildEither_first() {
        let first = MockMaxObject()
        let result = MaxObjectBuilder.buildEither(first: first)

        XCTAssertTrue(result === first)
    }

    func testMaxObjectBuilder_buildEither_second() {
        let second = MockMaxObject()
        let result = MaxObjectBuilder.buildEither(second: second)

        XCTAssertTrue(result === second)
    }

    func testMaxObjectBuilder_buildArray_returnsComposite() {
        let objs = [MockMaxObject(), MockMaxObject(), MockMaxObject()]

        let result = MaxObjectBuilder.buildArray(objs)

        guard let composite = result as? ObjeKit.CompositeMaxObject else {
            XCTFail("Expected CompositeMaxObject")
            return
        }

        XCTAssertEqual(composite.objects.count, 3)
    }

    func testMaxIOBuilder_buildBlock_returnsComposite() {
        let io1 = MockIOComponent()
        let io2 = MockIOComponent()

        let result = MaxIOBuilder.buildBlock(io1, io2)

        guard let composite = result as? ObjeKit.CompositeMaxIO else {
            XCTFail("Expected CompositeMaxIO")
            return
        }

        XCTAssertEqual(composite.io.count, 2)
//        XCTAssertTrue(composite.io[0] === io1)
//        XCTAssertTrue(composite.io[1] === io2)
    }
}
