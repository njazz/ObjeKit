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
        XCTAssertEqual(Atom.int(42), Atom.int(42))
        XCTAssertEqual(Atom.float(3.14), Atom.float(3.14))
        XCTAssertEqual(Atom.symbol("hello"), Atom.symbol("hello"))
        XCTAssertEqual(Atom.unknown, Atom.unknown)
        XCTAssertNotEqual(Atom.int(1), Atom.float(1.0))
        XCTAssertNotEqual(Atom.symbol("a"), Atom.symbol("b"))
    }

    func testMaxValueToAtomConversion() {
        XCTAssertEqual(Atom(MaxValue.int(1)), Atom.int(1))
        XCTAssertEqual(Atom(MaxValue.float(2.5)), Atom.float(2.5))
        XCTAssertEqual(Atom(MaxValue.symbol("hi")), Atom.symbol("hi"))
        XCTAssertEqual(Atom(MaxValue.unknown), Atom.unknown)
    }

    func testAtomToMaxValueConversion() {
        XCTAssertEqual(MaxValue(Atom.int(1)), MaxValue.int(1))
        XCTAssertEqual(MaxValue(Atom.float(2.5)), MaxValue.float(2.5))
        XCTAssertEqual(MaxValue(Atom.symbol("hi")), MaxValue.symbol("hi"))
        XCTAssertEqual(MaxValue(Atom.unknown), MaxValue.unknown)
    }

    func testAtomArrayConversionToMaxList() {
        let atoms: [Atom] = [.int(1), .float(2.0), .symbol("abc")]
        let maxList: MaxList = atoms.asMaxList
        XCTAssertEqual(maxList.count, 3)
        XCTAssertEqual(maxList[0], .int(1))
        XCTAssertEqual(maxList[1], .float(2.0))
        XCTAssertEqual(maxList[2], .symbol("abc"))
    }

    // TODO: todo
    func testMakeAtomPointerAndRoundtrip() {
        let originalAtoms: [Atom] = [.int(123), .float(4.5), .symbol("yo")]
        let (argc, argv) = makeAtomPointer(from: originalAtoms)

        XCTAssertEqual(argc, 3)

        let unpackedAtoms = atomsFromPointer(argc, argv)
        XCTAssertEqual(unpackedAtoms, originalAtoms)

        argv.deallocate() // Cleanup
    }

    func testMakeAtomPointerHandlesUnknown() {
        let atoms: [Atom] = [.unknown]
        let (argc, argv) = makeAtomPointer(from: atoms)
        XCTAssertEqual(argc, 1)

        let unpacked = atomsFromPointer(argc, argv)
        XCTAssertEqual(unpacked.first, .symbol("")) // Expect gensym("") fallback

        argv.deallocate()
    }

    func testEmptyPointerConversion() {
        let result = atomsFromPointer(0, nil)
        XCTAssertTrue(result.isEmpty)
    }
}
