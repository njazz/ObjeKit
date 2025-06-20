//
//  MaxValueTests.swift
//  ObjeKit
//
//  Created by alex on 20/06/2025.
//
import XCTest
@testable import ObjeKit

final class MaxValueTests: XCTestCase {

    func testInitFromAtom() {
        XCTAssertEqual(MaxValue(Atom.int(5)), .int(5))
        XCTAssertEqual(MaxValue(Atom.float(3.14)), .float(3.14))
        XCTAssertEqual(MaxValue(Atom.symbol("hello")), .symbol("hello"))
        XCTAssertEqual(MaxValue(Atom.unknown), .unknown)
    }

    func testInitFromAny() {
        XCTAssertEqual(MaxValue(any: 42), .int(42))
        XCTAssertEqual(MaxValue(any: 3.14), .float(3.14))
        XCTAssertEqual(MaxValue(any: Double(2.71)), .float(2.71))
        XCTAssertEqual(MaxValue(any: "text"), .symbol("text"))
        XCTAssertEqual(MaxValue(any: Int32(99)), .int(99))
        XCTAssertEqual(MaxValue(any: Int64(1234567890)), .int(1234567890))
        XCTAssertEqual(MaxValue(any: UInt(77)), .int(77))
        XCTAssertEqual(MaxValue(any: true), .int(1))
        XCTAssertEqual(MaxValue(any: false), .int(0))
        XCTAssertEqual(MaxValue(any: Date()), .unknown)
    }

    func testAccessors() {
        XCTAssertEqual(MaxValue.int(10).asInt, 10)
        XCTAssertNil(MaxValue.float(3.14).asInt)
        XCTAssertEqual(MaxValue.float(3.5).asDouble, 3.5)
        XCTAssertEqual(MaxValue.int(3).asDouble, 3.0)
        XCTAssertNil(MaxValue.symbol("test").asDouble)
        XCTAssertEqual(MaxValue.symbol("yo").asString, "yo")
        XCTAssertNil(MaxValue.int(9).asString)
    }

    func testArrayConversions() {
        let list: MaxList = [.int(1), .int(2), .int(3)]
        XCTAssertEqual(list.asIntArray, [1, 2, 3])
        XCTAssertEqual(list.asDoubleArray, [1.0, 2.0, 3.0])
        XCTAssertNil(list.asStringArray)

        let floatList: MaxList = [.float(1.0), .int(2)]
        XCTAssertEqual(floatList.asDoubleArray, [1.0, 2.0])
        XCTAssertNil(floatList.asIntArray)

        let stringList: MaxList = [.symbol("a"), .symbol("b")]
        XCTAssertEqual(stringList.asStringArray, ["a", "b"])
        XCTAssertNil(stringList.asIntArray)
    }

    func testAsAtoms() {
        let list: MaxList = [.int(1), .float(2.0), .symbol("x"), .unknown]
        let atoms = list.asAtoms
        XCTAssertEqual(atoms.count, 4)
        XCTAssertEqual(atoms[0], .int(1))
        XCTAssertEqual(atoms[1], .float(2.0))
        XCTAssertEqual(atoms[2], .symbol("x"))
        XCTAssertEqual(atoms[3], .unknown)
    }

    func testPrimitiveArrayConversion() {
        let intArray = [1, 2, 3]
        XCTAssertEqual(intArray.asMaxList, [.int(1), .int(2), .int(3)])

        let doubleArray = [1.1, 2.2]
        XCTAssertEqual(doubleArray.asMaxList, [.float(1.1), .float(2.2)])

        let stringArray = ["a", "b"]
        XCTAssertEqual(stringArray.asMaxList, [.symbol("a"), .symbol("b")])
    }

    func testConvertTo() {
        XCTAssertEqual(MaxValue.int(10).convert(to: Int.self), 10)
        XCTAssertEqual(MaxValue.int(10).convert(to: Double.self), 10.0)
        XCTAssertNil(MaxValue.symbol("abc").convert(to: Int.self))
        XCTAssertEqual(MaxValue.symbol("abc").convert(to: String.self), "abc")
        XCTAssertNil(MaxValue.unknown.convert(to: String.self))
    }

    func testUnpackSingle() {
        let list: MaxList = [.int(42)]
        let value: Int? = list.unpack()
        XCTAssertEqual(value, 42)

        let wrong: String? = list.unpack()
        XCTAssertNil(wrong)

        let multi: MaxList = [.int(1), .int(2)]
        let tooMany: Int? = multi.unpack()
        XCTAssertNil(tooMany)
    }

    func testUnpackDouble() {
        let list: MaxList = [.int(42), .float(3.14)]
        let values: (Int, Double)? = list.unpack()
        XCTAssertEqual(values?.0, 42)
        XCTAssertEqual(values?.1, 3.14)

        let wrong: (Int, String)? = list.unpack()
        XCTAssertNil(wrong)

        let tooShort: MaxList = [.int(1)]
        let notEnough: (Int, Int)? = tooShort.unpack()
        XCTAssertNil(notEnough)
    }
}
