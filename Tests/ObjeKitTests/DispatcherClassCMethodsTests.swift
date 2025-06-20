//
//  DummyDispatcherClass.swift
//  ObjeKit
//
//  Created by alex on 20/06/2025.
//


import XCTest
@testable import ObjeKit
@_implementationOnly import MSDKBridge

final class MaxInteropTests: XCTestCase {

    final class DummyDispatcher: DispatcherClass {
        var bangCalled = false
        var intValue: CLong?
        
        required init(){
            super.init()
            
            self.bangCalled = false
            self.intValue = nil
            
            onBang = { self.bangCalled = true }
            onInt = { v in self.intValue = v}
        }

    }

//    func test_ctor_allocates_and_sets_dispatcher() {
//        // Arrange
//        let dummyPtr = UnsafeMutableRawPointer(bitPattern: 0x1234)!
//        MaxDispatcher._classMap["\(dummyPtr)"] = dummyClass
//        MaxDispatcher._swiftClassMap["\(dummyPtr)"] = DummyDispatcher.self
//
//        // Act
//        let objPtr = _ctor(dummyPtr, 0, nil)
//
//        // Assert
//        XCTAssertNotNil(objPtr)
//        let obj = objPtr!.assumingMemoryBound(to: t_wrapped_object.self)
//        let box = Box.fromRaw(obj.pointee.box!, DummyDispatcher.self)
//        XCTAssertTrue(box.takeUnretainedValue().value is DummyDispatcher)
//    }

    func test_method_bang_calls_onBang() {
        let dummy = DummyDispatcher()
        let box = Box(dummy)
        let rawBox = box.toRaw()

        let obj = UnsafeMutablePointer<t_wrapped_object>.allocate(capacity: 1)
        obj.pointee.box = rawBox

        _method_bang(UnsafeMutableRawPointer(obj))

        XCTAssertTrue(dummy.bangCalled)
    }

    func test_method_int_passes_value() {
        let dummy = DummyDispatcher()
        let box = Box(dummy)
        let rawBox = box.toRaw()

        let obj = UnsafeMutablePointer<t_wrapped_object>.allocate(capacity: 1)
        obj.pointee.box = rawBox

        _method_int(UnsafeMutableRawPointer(obj), 42)

        XCTAssertEqual(dummy.intValue, 42)
    }

    func test_dtor_releases_box() {
        let dummy = DummyDispatcher()
        let box = Box(dummy)
        let rawBox = box.toRaw()

        let obj = UnsafeMutablePointer<t_wrapped_object>.allocate(capacity: 1)
        obj.pointee.box = rawBox

        let result = _dtor(ptr: UnsafeMutableRawPointer(obj))

        XCTAssertNil(result)
        // Could add reference-count assertion if needed
    }
}


