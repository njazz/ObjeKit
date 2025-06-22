//
//  MaxValue.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 27/05/2025.
//

/// Low-level Max SDK type wrap
///
/// Supported types: float, int, symbol
public enum MaxValue {
    case float(Double)
    case int(Int64)
    case symbol(String)

    case unknown
}

// MARK: -

extension MaxValue: Equatable {
    public static func == (lhs: MaxValue, rhs: MaxValue) -> Bool {
        switch (lhs, rhs) {
        case let (.float(a), .float(b)): return a == b
        case let (.int(a), .int(b)): return a == b
        case let (.symbol(a), .symbol(b)): return a == b
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}

// MARK: -

public typealias MaxList = [MaxValue]

extension MaxValue {
    /// Wraps a value of any common Swift type into a MaxValue.
    /// Supported: Int, Double, Float, String, Bool, Int32/64, UInt.
    /// Falls back to `.unknown` for unsupported types.
    public init(any value: Any) {
        switch value {
        case let int as Int64:
            self = .int(int)
        case let double as Double:
            self = .float(double)
        case let float as Float:
            self = .float(Double(float))
        case let string as String:
            self = .symbol(string)
        case let int32 as Int32:
            self = .int(Int64(int32))
        case let int64 as Int64:
            self = .int(Int64(int64))
        case let uint as UInt:
            self = .int(Int64(uint))
        case let bool as Bool:
            self = .int(bool ? 1 : 0)
        default:
            self = .unknown
            MaxLogger.shared.warning("Unsupported MaxValue type: \(type(of: value))")
        }
    }
}

// MARK: -

extension MaxValue {
    var asInt: Int64? {
        if case let .int(i) = self { return i } else { return nil }
    }

    var asDouble: Double? {
        switch self {
        case let .float(f): return f
        case let .int(i): return Double(i)
        default: return nil
        }
    }

    var asString: String? {
        if case let .symbol(s) = self { return s } else { return nil }
    }

    var asBool: Bool? {
        if case let .int(i) = self { return i != 0 } else { return nil }
    }
}

// MARK: - Array conversions

extension Array where Element == MaxValue {
    var asAtoms: [MaxValue] {
        map(MaxValue.init)
    }

    var asIntArray: [Int64]? {
        allSatisfy {
            if case .int = $0 { true } else { false }
        } ? map { ($0.asInt)! } : nil
    }

    var asDoubleArray: [Double]? {
        allSatisfy {
            switch $0 {
            case .int, .float: true
            default: false
            }
        } ? map { $0.asDouble! } : nil
    }

    var asStringArray: [String]? {
        allSatisfy {
            if case .symbol = $0 { true } else { false }
        } ? map { $0.asString! } : nil
    }
}

extension Array where Element == Int64 {
    var asMaxList: MaxList { map { .int($0) } }
}

extension Array where Element == Double {
    var asMaxList: MaxList { map { .float($0) } }
}

extension Array where Element == String {
    var asMaxList: MaxList { map { .symbol($0) } }
}

// MARK: - Lossless unpacking

public protocol MaxValueConvertible {}

extension Int: MaxValueConvertible {}
extension Int16: MaxValueConvertible {}
extension Int32: MaxValueConvertible {}
extension UInt: MaxValueConvertible {}
extension UInt16: MaxValueConvertible {}
extension UInt32: MaxValueConvertible {}
extension Double: MaxValueConvertible {}
extension Float: MaxValueConvertible {}
extension String: MaxValueConvertible {}

// MARK: -

public extension MaxValue {
    /// Attempts to convert the value to a desired Swift type, if representable.
    func convert<T: MaxValueConvertible>(to type: T.Type) -> T? {
        switch (self, type) {
        case (.int(let i), is Int.Type): return i as? T
        case (.float(let f), is Double.Type): return f as? T
        case (.int(let i), is Double.Type): return Double(i) as? T
        case (.symbol(let s), is String.Type): return s as? T
        case (.float(let f), is Float.Type): return Float(f) as? T
        case (.int(let i), is UInt.Type): return UInt(exactly: i) as? T
        default: return nil
        }
    }
}

extension MaxList {
    public func unpack<T1>() -> T1? where T1: MaxValueConvertible {
        guard count == 1 else { return nil }
        return self[0].convert(to: T1.self)
    }

    subscript<T: MaxValueConvertible>(typed index: Int) -> T? {
        guard index < count else { return nil }
        return self[index].convert(to: T.self)
    }

    public func unpack<T1, T2>() -> (T1, T2)? where T1: MaxValueConvertible, T2: MaxValueConvertible {
        guard count == 2 else { return nil }
        guard
            let v1 = self[0].convert(to: T1.self),
            let v2 = self[1].convert(to: T2.self)
        else {
            return nil
        }
        return (v1, v2)
    }

    func unpack<T1, T2, T3>() -> (T1, T2, T3)? where T1: MaxValueConvertible, T2: MaxValueConvertible, T3: MaxValueConvertible {
        guard count == 3,
              let v1 = self[0].convert(to: T1.self),
              let v2 = self[1].convert(to: T2.self),
              let v3 = self[2].convert(to: T3.self) else { return nil }
        return (v1, v2, v3)
    }

    func unpack<T1, T2, T3, T4>() -> (T1, T2, T3, T4)? where T1: MaxValueConvertible, T2: MaxValueConvertible, T3: MaxValueConvertible, T4: MaxValueConvertible {
        guard count == 4,
              let v1 = self[0].convert(to: T1.self),
              let v2 = self[1].convert(to: T2.self),
              let v3 = self[2].convert(to: T3.self),
              let v4 = self[3].convert(to: T4.self) else { return nil }
        return (v1, v2, v3, v4)
    }

    func unpack<T1, T2, T3, T4, T5>() -> (T1, T2, T3, T4, T5)? where T1: MaxValueConvertible, T2: MaxValueConvertible, T3: MaxValueConvertible, T4: MaxValueConvertible, T5: MaxValueConvertible {
        guard count == 5,
              let v1 = self[0].convert(to: T1.self),
              let v2 = self[1].convert(to: T2.self),
              let v3 = self[2].convert(to: T3.self),
              let v4 = self[3].convert(to: T4.self),
              let v5 = self[4].convert(to: T5.self) else { return nil }
        return (v1, v2, v3, v4, v5)
    }
}

/*

 To reduce boilerplate and improve flexibility in your MaxValue system while maintaining safety and clarity, consider the following enhancements:
 ✅ 1. Use LosslessStringConvertible for broader conversion

 Instead of manually supporting each numeric/string type, leverage protocols like LosslessStringConvertible and BinaryInteger / BinaryFloatingPoint.

 public protocol MaxValueConvertible {
     static func fromMaxValue(_ value: MaxValue) -> Self?
 }

 extension MaxValue {
     func convert<T: MaxValueConvertible>(to: T.Type = T.self) -> T? {
         T.fromMaxValue(self)
     }
 }

 Then conform types like:

 extension Int: MaxValueConvertible {
     public static func fromMaxValue(_ value: MaxValue) -> Self? {
         switch value {
         case .int(let i): return Self(i)
         case .float(let f): return Self(exactly: f)
         default: return nil
         }
     }
 }

 extension Double: MaxValueConvertible {
     public static func fromMaxValue(_ value: MaxValue) -> Self? {
         switch value {
         case .float(let f): return f
         case .int(let i): return Double(i)
         default: return nil
         }
     }
 }

 extension String: MaxValueConvertible {
     public static func fromMaxValue(_ value: MaxValue) -> Self? {
         if case .symbol(let s) = value { return s }
         return nil
     }
 }

     You now only need to write one .convert(to: T.self) instead of many specific accessors.

 ✅ 2. Replace .asIntArray, .asDoubleArray boilerplate with generic converter

 Add a generic version:

 extension Array where Element == MaxValue {
     func convertAll<T: MaxValueConvertible>(to type: T.Type = T.self) -> [T]? {
         self.allSatisfy { $0.convert(to: T.self) != nil } ?
             self.compactMap { $0.convert(to: T.self) } : nil
     }
 }

 Then replace:

 let doubles = list.convertAll(to: Double.self)
 let ints = list.convertAll(to: Int.self)
 let strings = list.convertAll(to: String.self)

 Much more concise than separate accessors.
 ✅ 3. Unpacking with variadic generics workaround

 While Swift doesn’t support variadic generics (yet), you can generalize the pattern by using tuples and MaxValueConvertible:

 public extension MaxList {
     func unpack<T: MaxValueConvertible>(_ types: T.Type...) -> [T]? {
         guard count == types.count else { return nil }
         return zip(self, types).compactMap { val, type in
             val.convert(to: type)
         }.count == count ? zip(self, types).compactMap { $0.convert(to: $1) } : nil
     }
 }

 Usage:

 if let values = list.unpack(Int.self, Double.self) {
     let intValue: Int = values[0]
     let doubleValue: Double = values[1]
 }

 Cleaner than duplicating for each tuple arity.
 ✅ 4. Generalized init(any:) with helper

 To avoid large switch blocks, use:

 public extension MaxValue {
     init(any value: Any) {
         switch value {
         case let convertible as MaxValueConvertible:
             self = MaxValue.wrap(convertible) ?? .unknown
         default:
             self = .unknown
         }
     }

     private static func wrap<T: MaxValueConvertible>(_ value: T) -> MaxValue? {
         switch value {
         case let v as Int: return .int(v)
         case let v as Double: return .float(v)
         case let v as Float: return .float(Double(v))
         case let v as String: return .symbol(v)
         case let v as Int32: return .int(Int(v))
         case let v as Int64: return .int(Int(v))
         case let v as UInt: return .int(Int(v))
         case let v as Bool: return .int(v ? 1 : 0)
         default: return nil
         }
     }
 }

 ✅ 5. Optional: ExpressibleBy...Literal

 This allows you to do let value: MaxValue = 42 or "foo":

 extension MaxValue: ExpressibleByIntegerLiteral {
     public init(integerLiteral value: Int) { self = .int(value) }
 }

 extension MaxValue: ExpressibleByFloatLiteral {
     public init(floatLiteral value: Double) { self = .float(value) }
 }

 extension MaxValue: ExpressibleByStringLiteral {
     public init(stringLiteral value: String) { self = .symbol(value) }
 }

 */
