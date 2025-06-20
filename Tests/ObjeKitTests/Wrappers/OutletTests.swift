//
//  MaxOutputTests.swift
//  ObjeKit
//
//  Created by alex on 20/06/2025.
//

import XCTest
@testable import ObjeKit

//struct MaxValueTest: Equatable {
//    let intValue: Int
//    init(_ value: Int) { self.intValue = value }
//}
//
//final class TestVisitor: MaxIOVisitor {
//    func visit<T>(_ outlet: ObjeKit.Outlet<T>) {
//        
//    }
//    
//    var didVisit = false
//    func visit(_ inlet: Inlet) {
//        didVisit = true
//    }
//}


// MARK: -

final class MaxOutputTests: XCTestCase {
    func testMaxOutputInit() {
        let output = MaxOutput()
//        XCTAssertEqual(output.index, .index(0))
    }

    func testMaxOutputSenderBang() {
        let output = MaxOutput()
        output.wrappedValue.bang() // no crash = pass
    }

    func testMaxOutputOnChange() {
        let output = MaxOutput()
        var didChange = false
        var changedValue: MaxList?

        var mutableOutput = output
        mutableOutput.onChange = { value in
            didChange = true
            changedValue = value
        }

        let testList: MaxList = [.int(1), .float(2.0)]
        mutableOutput.onChange?(testList)
        XCTAssertTrue(didChange)
        XCTAssertEqual(changedValue, testList)
    }
}
