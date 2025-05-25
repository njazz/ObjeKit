//
//  MaxMethod.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//

@propertyWrapper
struct MaxMethod<Arg, Result> {
    private var method: (Arg) -> Result
    let name: String
    
//    init(_ name: String) {
//        self.name = name
//    }

    init(wrappedValue: @escaping (Arg) -> Result, _ name: String) {
        self.method = wrappedValue
        self.name = name
    }

    var wrappedValue: (Arg) -> Result {
        get { method }
        set { method = newValue }
    }
    
    var projectedValue: String {
        return name
    }
}
