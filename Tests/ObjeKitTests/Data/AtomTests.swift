//
//  AtomTests.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 20/06/2025.
//
import XCTest
@testable import ObjeKit

final class AtomTests: XCTestCase {

    func testAtomEquatable() {
        XCTAssertEqual(MaxValue.int(42), MaxValue.int(42))
        XCTAssertEqual(MaxValue.float(3.14), MaxValue.float(3.14))
        XCTAssertEqual(MaxValue.symbol("hello"), MaxValue.symbol("hello"))
        XCTAssertEqual(MaxValue.unknown, MaxValue.unknown)
        XCTAssertNotEqual(MaxValue.int(1), MaxValue.float(1.0))
        XCTAssertNotEqual(MaxValue.symbol("a"), MaxValue.symbol("b"))
    }

//    func testMaxValueToAtomConversion() {
//        XCTAssertEqual(MaxValue(any:MaxValue.int(1)), MaxValue.int(1))
//        XCTAssertEqual(MaxValue(any:MaxValue.float(2.5)), MaxValue.float(2.5))
//        XCTAssertEqual(MaxValue(any:MaxValue.symbol("hi")), MaxValue.symbol("hi"))
//        XCTAssertEqual(MaxValue(any:MaxValue.unknown), MaxValue.unknown)
//    }
//
//    func testAtomToMaxValueConversion() {
//        XCTAssertEqual(MaxValue(any:MaxValue.int(1)), MaxValue.int(1))
//        XCTAssertEqual(MaxValue(any:MaxValue.float(2.5)), MaxValue.float(2.5))
//        XCTAssertEqual(MaxValue(any:MaxValue.symbol("hi")), MaxValue.symbol("hi"))
//        XCTAssertEqual(MaxValue(any:MaxValue.unknown), MaxValue.unknown)
//    }
//
//    func testAtomArrayConversionToMaxList() {
//        let atoms: [MaxValue] = [.int(1), .float(2.0), .symbol("abc")]
//        let maxList: MaxList = atoms.asMaxList
//        XCTAssertEqual(maxList.count, 3)
//        XCTAssertEqual(maxList[0], .int(1))
//        XCTAssertEqual(maxList[1], .float(2.0))
//        XCTAssertEqual(maxList[2], .symbol("abc"))
//    }

    // TODO: todo
//    func testMakeAtomPointerAndRoundtrip() {
//        let originalAtoms: [Atom] = [.int(123), .float(4.5), .symbol("yo")]
//        let (argc, argv) = makeAtomPointer(from: originalAtoms)
//
//        XCTAssertEqual(argc, 3)
//
//        let unpackedAtoms = atomsFromPointer(argc, argv)
//        XCTAssertEqual(unpackedAtoms, originalAtoms)
//
//        argv.deallocate() // Cleanup
//    }
//
//    func testMakeAtomPointerHandlesUnknown() {
//        let atoms: [Atom] = [.unknown]
//        let (argc, argv) = makeAtomPointer(from: atoms)
//        XCTAssertEqual(argc, 1)
//
//        let unpacked = atomsFromPointer(argc, argv)
//        XCTAssertEqual(unpacked.first, .symbol("")) // Expect gensym("") fallback
//
//        argv.deallocate()
//    }

    func testEmptyPointerConversion() {
        let result = maxListFromPointer(0, nil)
        XCTAssertTrue(result.isEmpty)
    }
}
