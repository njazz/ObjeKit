//
//  DispatcherClassTests.swift
//  ObjeKit
//
//  Created by alex on 20/06/2025.
//
import XCTest
@testable import ObjeKit

final class DispatcherClassTests: XCTestCase {
    
    func testInitialStateOfDispatcherClass() {
        let dispatcher = DispatcherClass()
        
        XCTAssertNil(dispatcher.object)
        XCTAssertEqual(dispatcher.arguments.count, 0)
        XCTAssertEqual(dispatcher.requiredArguments, 0)
        XCTAssertEqual(dispatcher.inlets.count, 0)
        XCTAssertEqual(dispatcher.outlets.count, 0)
        XCTAssertEqual(dispatcher.attributes.count, 0)
        
        // Confirm handlers exist
        dispatcher.onBang()
        dispatcher.onDouble(1.23)
        dispatcher.onInt(42)
        dispatcher.onList([])
    }

    
    func testSelectorAssignment() {
        let dispatcher = DispatcherClass()
        var wasCalled = false
        dispatcher.onSelector["foo"] = { values in
            wasCalled = true
        }

        dispatcher.onSelector["foo"]?([.int(1)])
        XCTAssertTrue(wasCalled)
    }

    func testArgumentSetterSuccess() {
        var didSet = false
        let arg = ArgumentData(untypedSetter: { val in
            if case .float(let f) = val {
                didSet = (f == 3.14)
                return true
            }
            return false
        }, optional: false, description: "A float value")

        let result = arg.untypedSetter(.float(3.14))
        XCTAssertTrue(result)
        XCTAssertTrue(didSet)
    }

    func testArgumentSetterFailure() {
        let arg = ArgumentData(untypedSetter: { _ in false }, optional: false, description: nil)
        XCTAssertFalse(arg.untypedSetter(.int(123)))
    }

//    func testDispatcherClassMetadataStructure() {
//        let dummyClass = UnsafeMutablePointer<t_class>.allocate(capacity: 1)
//        defer { dummyClass.deallocate() }
//
//        let metadata = DispatcherClassMetadata(
//            maxClass: dummyClass,
//            objectType: DispatcherClass.self,
//            inletCount: 2,
//            outletCount: 1
//        )
//
//        XCTAssertEqual(metadata.inletCount, 2)
//        XCTAssertEqual(metadata.outletCount, 1)
//    }

}
