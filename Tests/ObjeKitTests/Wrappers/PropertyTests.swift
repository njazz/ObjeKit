//
//  MaxBindingTests.swift
//  ObjeKit
//
//  Created by alex on 20/06/2025.
//

import XCTest
@testable import ObjeKit

// MARK: -

final class MaxBindingTests: XCTestCase {
    
    func testGetSet() {
        var value = 10
        var binding = MaxBinding<Int>(
            get: { value },
            set: { value = $0 },
            observe: { _ in }
        )
        
        XCTAssertEqual(binding.wrappedValue, 10)
        binding.wrappedValue = 20
        XCTAssertEqual(value, 20)
    }
    
    func testCallAsFunction() {
        var value = 5
        let binding = MaxBinding<Int>(
            get: { value },
            set: { value = $0 },
            observe: { _ in }
        )
        
        binding(99)
        XCTAssertEqual(value, 99)
    }
    
    func testObserve() {
        var value = 42
        var observed: Int? = nil
        
        let binding = MaxBinding<Int>(
            get: { value },
            set: { value = $0 },
            observe: { cb in
                cb(value) // simulate push
            }
        )
        
        binding.observe { newValue in
            observed = newValue
        }
        
        XCTAssertEqual(observed, 42)
    }
}


// MARK: -

final class MaxStateTests: XCTestCase {
    
    func testWrappedValue() {
        let state = MaxState(wrappedValue: 123)
        XCTAssertEqual(state.wrappedValue, 123)
        
        state.wrappedValue = 456
        XCTAssertEqual(state.wrappedValue, 456)
    }

    func testProjectedValueBinding() {
        let state = MaxState(wrappedValue: "hello")
        var binding = state.projectedValue
        
        XCTAssertEqual(binding.wrappedValue, "hello")
        
        binding.wrappedValue = "world"
        XCTAssertEqual(state.wrappedValue, "world")
    }

    func testObserversCalled() {
        let state = MaxState(wrappedValue: 100)
        let binding = state.projectedValue

        var observed: [Int] = []
        binding.observe { newVal in
            observed.append(newVal)
        }

        state.wrappedValue = 200
        state.wrappedValue = 300

        XCTAssertEqual(observed, [100, 200, 300]) // includes initial
    }
}

