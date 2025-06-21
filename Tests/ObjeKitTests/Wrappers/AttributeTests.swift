//
//  AttributeStyleTests.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 20/06/2025.
//

import XCTest
@testable import ObjeKit

final class AttributeStyleTests: XCTestCase {
    
    func testRawValueConversion() {
        XCTAssertEqual(AttributeStyle.m_text.rawValue, "text")
        XCTAssertEqual(AttributeStyle.m_onoff.rawValue, "onoff")
        XCTAssertEqual(AttributeStyle.m_enumindex.rawValue, "enumindex")
    }

    func testInitFromRawValue() {
        XCTAssertEqual(AttributeStyle(rawValue: "text"), .m_text)
        XCTAssertEqual(AttributeStyle(rawValue: "onoff"), .m_onoff)
        XCTAssertNil(AttributeStyle(rawValue: "unknown"))
    }
}

// MARK: -

final class AttributeTests: XCTestCase {
    
    func testAttributeWrappedValue() {
        var internalValue = "hello"
        
        let attribute = Attribute<String> {
            MaxBinding<String>(
                get: { internalValue },
                set: { internalValue = $0 },
                observe: { _ in }
            )
        }
        
        XCTAssertEqual(attribute.wrappedValue, "hello")
        attribute.wrappedValue = "world"
        XCTAssertEqual(internalValue, "world")
    }
    
    func testAttributeOnChange() {
        var value = 123
        var observed: Int?

        let attr = Attribute<Int> {
            MaxBinding<Int>(
                get: { value },
                set: { value = $0 },
                observe: { callback in
                    callback(value) // simulate immediate update
                }
            )
        }

        attr.onChange = { newValue in
            observed = newValue
        }

        // update to simulate trigger again
        attr.wrappedValue = 456
        XCTAssertEqual(observed, 456)
    }
}

// MARK: -

final class MaxAttributeConformanceTests: XCTestCase {
    
    func testMaxAttributeValueConformance() {
        let _: MaxAttributeValue = 5
        let _: MaxAttributeValue = 5.0
        let _: MaxAttributeValue = "hello"
        let _: MaxAttributeValue = [1, 2, 3]
        let _: MaxAttributeValue = [1.0, 2.0, 3.0]
        let _: MaxAttributeValue = ["one", "two"]
    }

    func testMaxAttributeValueElementConformance() {
        let _: MaxAttributeValueElement = 5
        let _: MaxAttributeValueElement = 5.0
        let _: MaxAttributeValueElement = "hi"
//        let _: MaxAttributeValueElement = MaxValue.atom(42) // Assuming such case
    }

    func testArrayConformance() {
        let _: MaxAttributeValue = [42, 1337]
        let _: MaxAttributeValue = [1.0, 2.0]
        let _: MaxAttributeValue = ["a", "b", "c"]
    }
}

