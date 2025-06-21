//
//  MyIntWrapper.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 20/06/2025.
//
import XCTest
@testable import ObjeKit

struct MyIntWrapper: Initializable, Equatable {
    var value: Int = 0
    init() {}
    init(_ value: Int) { self.value = value }
}

final class BoxTests: XCTestCase {

    func testBoxStoresValue() {
        let box = Box(MyIntWrapper(42))
        XCTAssertEqual(box.value, MyIntWrapper(42))
    }

    func testBoxCreateInitializable() {
        let box = Box.create(MyIntWrapper.self)
        XCTAssertEqual(box.value, MyIntWrapper()) // Should be default value
    }

    func testBoxPointerRoundTrip() {
        let originalBox = Box(MyIntWrapper(100))
        let rawPointer = originalBox.toRaw()
        let recovered = Box<MyIntWrapper>.fromRaw(rawPointer, MyIntWrapper.self).takeRetainedValue()
        XCTAssertEqual(recovered.value, MyIntWrapper(100))
    }

    func testBoxReleaseDecrementsRetainCount() {
        let box = Box(MyIntWrapper(999))
        let retained = Unmanaged.passRetained(box)
        retained.release() // should not crash
    }

    func testManualRetainReleaseBalance() {
        let box = Box(MyIntWrapper(7))
        let retained = box.toRaw()

        // Retain count +1 (from `toRaw`)
        let unmanaged = Box<MyIntWrapper>.fromRaw(retained, MyIntWrapper.self)
        XCTAssertEqual(unmanaged.takeUnretainedValue().value, MyIntWrapper(7))

        // release manually
        unmanaged.release()
    }
}
