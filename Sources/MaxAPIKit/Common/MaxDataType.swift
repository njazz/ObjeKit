//
//  MaxDataType.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//


// minimal
public enum MaxValue {
    case int(Int)
    case float(Double)
    case symbol(String)
    case unknown
}

// MARK: -

// 1. Define data types
public enum MaxDataType {
    case bang
  
    case int
  case float
    
  case symbol(String)
  case list
  
    case selector(name: String, contents: [MaxDataType])
  case bool
  
    case anything
}

// 2. Helper protocol to map data types to Swift types
//protocol MaxDataTypeMap {
//  associatedtype Value
//}
//
//extension MaxDataTypeMap where Self == MaxDataType.int {
//  typealias Value = Int
//}
//
//extension MaxDataTypeMap where Self == MaxDataType.bang {
//  typealias Value = Void
//}
//
//extension MaxDataTypeMap where Self == MaxDataType.float {
//  typealias Value = Float
//}
//
//extension MaxDataTypeMap where Self == MaxDataType.symbol {
//  typealias Value = String
//}
//
//extension MaxDataTypeMap where Self == MaxDataType.list {
//  typealias Value = [MaxAtom]
//}

protocol MaxDataTypeMarker {
  associatedtype Value
}

struct IntType: MaxDataTypeMarker {
  typealias Value = Int
}
struct FloatType: MaxDataTypeMarker {
  typealias Value = Double
}
struct SymbolType: MaxDataTypeMarker {
  typealias Value = String
}

// 3. Define MaxAtom to hold any atom type
enum MaxAtom {
  case int(Int)
  case float(Float)
  case symbol(String)
    case list([MaxAtom])
  case bang
  // Add others as needed
}

// 4. Refine your property wrappers with generic constraints


@propertyWrapper
struct Inlet_E<Marker: MaxDataTypeMarker> {
  var wrappedValue: (Marker.Value) -> Void
  init(wrappedValue: @escaping (Marker.Value) -> Void) {
    self.wrappedValue = wrappedValue
  }
}


//@propertyWrapper
//struct Inlet<T> {
//  let type: MaxDataType
//  var wrappedValue: (T) -> Void
//
//  init(_ type: MaxDataType, wrappedValue: @escaping (T) -> Void) {
//    // Ideally add runtime or compile-time checks here
//    self.type = type
//    self.wrappedValue = wrappedValue
//  }
//}
//
//@propertyWrapper
//struct Outlet<T> {
//  let type: MaxDataType
//  private var lastValue: T?
//
//  var wrappedValue: T? {
//    get { lastValue }
//    set { lastValue = newValue }
//  }
//
//  init(_ type: MaxDataType) {
//    self.type = type
//  }
//
//  func send(_ value: T) {
//    // Call C API under the hood here
//  }
//}
