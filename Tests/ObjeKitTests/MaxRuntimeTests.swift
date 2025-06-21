//
//  MaxRuntimeTests.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 20/06/2025.
//


import XCTest
@testable import ObjeKit
@_implementationOnly import MSDKBridge

//func _poststring(_ v: UnsafePointer<CChar>?){}
//func _warning(_ v: UnsafePointer<CChar>?){}
//func _error(_ v: UnsafePointer<CChar>?){}

final class MaxRuntimeTests: XCTestCase {

    override func tearDown() {
        // Restore original functions after each test
        MaxRuntime._postImpl = poststring
        MaxRuntime._warningImpl = _warning
        MaxRuntime._errorImpl = _error
    }

    func testPostCallsPostString() {
        var captured: UnsafePointer<CChar>?
        MaxRuntime._postImpl = {
            captured = $0
            guard captured != nil else { XCTAssert(false); return }
            XCTAssertEqual(String(cString: captured!), "hello")
        }

        MaxRuntime.post("hello")
        
    }

    func testWarningCallsWarning() {
        var captured: UnsafePointer<CChar>?
        MaxRuntime._warningImpl = {
            captured = $0
            guard captured != nil else { XCTAssert(false); return }
            XCTAssertEqual(String(cString: captured!), "this is a warning")
        }

        MaxRuntime.warning("this is a warning")
        
        
    }

    func testErrorCallsError() {
        var captured: UnsafePointer<CChar>?
        MaxRuntime._errorImpl = {
            captured = $0
            guard captured != nil else { XCTAssert(false); return }
            XCTAssertEqual(String(cString: captured!), "fatal error")
        }

        MaxRuntime.error("fatal error")
        
    }
}
