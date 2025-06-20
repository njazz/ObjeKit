//
//  MockDispatcherClass.swift
//  ObjeKit
//
//  Created by alex on 20/06/2025.
//


import XCTest
@testable import ObjeKit
@_implementationOnly import MSDKBridge

// Mocks or stubs you must create:
class MockDispatcherClass: DispatcherClass {
//    var outlets: [UnsafeMutableRawPointer] = []
//    var inlets: [UnsafeMutableRawPointer] = []
//    var arguments: [ArgumentData] = []
//    var requiredArguments: Int = 0

    // onBang etc handlers (optional)
    var onBangCalled = false
    var onIntCalled = false
    var onDoubleCalled = false
    var onSelectorCalledNames: [String] = []

    required init() {
        super.init()
    }
}

// Mock runtime to capture post/warning/error
class MockMaxRuntime {
    static var posts: [String] = []
    static var warnings: [String] = []
    static var errors: [String] = []

    static func post(_ message: String) {
        posts.append(message)
    }
    static func warning(_ message: String) {
        warnings.append(message)
    }
    static func error(_ message: String) {
        errors.append(message)
    }

    static func reset() {
        posts = []
        warnings = []
        errors = []
    }
}

// Override globals/functions used in AttachInstance to call MockMaxRuntime
func MaxRuntime_post(_ message: String) { MockMaxRuntime.post(message) }
func MaxRuntime_warning(_ message: String) { MockMaxRuntime.warning(message) }
func MaxRuntime_error(_ message: String) { MockMaxRuntime.error(message) }

// You will have to swizzle or inject these in your test target or use dependency injection to redirect calls

final class AttachInstanceTests: XCTestCase {
    
    var dispatcher: MockDispatcherClass!
    var objectPtr: UnsafeMutablePointer<t_object>!

    override func setUp() {
        super.setUp()
        dispatcher = MockDispatcherClass()
        // Create a dummy t_object pointer (just allocate raw memory for test)
        objectPtr = UnsafeMutablePointer<t_object>.allocate(capacity: 1)
        // Clear runtime logs
        MockMaxRuntime.reset()
    }
    
    override func tearDown() {
        objectPtr.deallocate()
        super.tearDown()
    }

    func testVisitOutletAddsOutletToWrapper() {
        let attach = AttachInstance(objectPtr, wrapper: dispatcher)
        
        // Create a dummy Outlet<Int> (you must define this struct/class accordingly)
        let outlet = Outlet<Int>(bindingProvider:{MaxBinding(get:{0}, set:{_ in}, observe:{_ in})})  // adjust constructor to your actual API
        
        attach.visit(outlet)
        
        XCTAssertEqual(dispatcher.outlets.count, 1)
        XCTAssertTrue(MockMaxRuntime.posts.contains(where: { $0.contains("Registering outlet") }))
    }
    
    func testVisitInletAddsInletToWrapperAndAssignsHandler() {
        let attach = AttachInstance(objectPtr, wrapper: dispatcher)
        
        // Create dummy inlet of kind bang
        let inlet = Inlet(.available) { (v:Int) in }
        
        attach.visit(inlet)
        
        XCTAssertEqual(dispatcher.inlets.count, 1)
        XCTAssertNotNil(dispatcher.onBang) // check handler assigned
        
        XCTAssertTrue(MockMaxRuntime.posts.contains(where: { $0.contains("Registering method") }))
    }
    
    func testVisitArgumentAppendsArgumentAndUpdatesFlags() {
        let attach = AttachInstance(objectPtr, wrapper: dispatcher)
        
        let argument = Argument<Int>(optional: false, description: "Test Arg", setter: { _ in })
        
        let result = attach.visit(argument)
        
        XCTAssertTrue(result)
        XCTAssertEqual(dispatcher.arguments.count, 1)
        XCTAssertEqual(dispatcher.requiredArguments, 1)
        
        XCTAssertTrue(MockMaxRuntime.posts.contains(where: { $0.contains("Registering") }))
    }
    
    func testVisitArgumentLogsWarningIfNonOptionalAfterOptional() {
        let attach = AttachInstance(objectPtr, wrapper: dispatcher)
        
        let optionalArg = Argument<Int>(optional: true, description: nil, setter: { _ in })
        _ = attach.visit(optionalArg)
        
        let nonOptionalArg = Argument<Int>(optional: false, description: nil, setter: { _ in })
        _ = attach.visit(nonOptionalArg)
        
        XCTAssertTrue(MockMaxRuntime.warnings.contains(where: { $0.contains("Non-optional argument at index") }))
    }
    
    // Add more tests for edge cases, multiple arguments, outlet onChange closure behavior etc.
}
