//
//  conforming.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 20/06/2025.
//


import XCTest

@testable import ObjeKit
@_implementationOnly import MSDKBridge

// Dummy class conforming to MaxObject for testing
final class DummyMaxObject2: MaxObject {
    static var className: String { "dummy.maxobj" }
    
    var io: MaxIOComponent = DummyIO2()
    var arguments: [Any] = []
    var requiredArguments: Int = 0

    func onBang() { wasBanged = true }
    func onInt(_ value: Int) { receivedInt = value }
    func onDouble(_ value: Double) { receivedFloat = value }
    func onList(_ list: [MaxValue]) { receivedList = list }
    var onSelector: [String: ([MaxValue]) -> Void] = [:]

    // For test verification
    var wasBanged = false
    var receivedInt: Int?
    var receivedFloat: Double?
    var receivedList: [MaxValue]?
}

final class DummyIO2: MaxIOComponent {
    func accept(visitor: MaxIOVisitor) {}
}

final class MaxDispatcherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Reset state before each test
//        MaxDispatcher._classMap = [:]
//        MaxDispatcher._swiftClassMap = [:]
        
        MaxDispatcher._metadata = [:]
    }

//    func testSetupRegistersClass() {
//        MaxDispatcher.setup(DummyMaxObject.self)
//        
//        let found = MaxDispatcher._swiftClassMap.values.contains { $0 == DummyMaxObject.self }
//        XCTAssertTrue(found, "Expected DummyMaxObject to be registered in _swiftClassMap")
//    }

    func testCtorFailsWithUnregisteredClass() {
        let result = _ctor(nil, 0, nil)
        XCTAssertNil(result, "Expected ctor to return nil when class isn't registered")
    }

//    func testSetupStoresMatchingClassPointers() {
//        MaxDispatcher.setup(DummyMaxObject.self)
//
//        // Simulate the same logic as `_ctor` does to get the key
//        guard let current_ctor: method_ctor = get_next_ctor(_ctor) else {
//            XCTFail("get_next_ctor returned nil")
//            return
//        }
//
//        let ctor_ptr = unsafeBitCast(current_ctor, to: UnsafeRawPointer.self)
//        let classMapContainsKey = MaxDispatcher._classMap["\(ctor_ptr)"] != nil
//        let swiftMapContainsKey = MaxDispatcher._swiftClassMap["\(ctor_ptr)"] != nil
//
//        XCTAssertTrue(classMapContainsKey, "Expected _classMap to contain ctor_ptr")
//        XCTAssertTrue(swiftMapContainsKey, "Expected _swiftClassMap to contain ctor_ptr")
//    }

    // Additional test examples would go here — but testing the _method_* functions
    // requires setting up raw memory, or mocking object_alloc and related functions.
}
