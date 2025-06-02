//
//  MaxValue.swift
//  ObjeKit
//
//  Created by alex on 27/05/2025.
//


// minimal
public enum MaxValue {
    case int(Int)
    case float(Double)
    case symbol(String)
    case unknown
}

public typealias MaxList = [MaxValue]

extension MaxValue {
    init(_ atom: Atom) {
        switch atom {
        case .float(let value):
            self = .float(value)
        case .int(let value):
            self = .int(value)
        case .symbol(let value):
            self = .symbol(value)
        case .unknown:
            self = .unknown
        }
    }
}

extension MaxValue {
    public init(any value: Any) {
        switch value {
        case let int as Int:
            self = .int(int)
        case let double as Double:
            self = .float(double)
        case let float as Float:
            self = .float(Double(float))
        case let string as String:
            self = .symbol(string)
        case let int32 as Int32:
            self = .int(Int(int32))
        case let int64 as Int64:
            self = .int(Int(int64))
        case let uint as UInt:
            self = .int(Int(uint))
        case let bool as Bool:
            self = .int(bool ? 1 : 0)
        default:
            self = .unknown
        }
    }
}


//extension Array where Element == MaxValue {
//    var asAtoms: [Atom] {
//        self.map(Atom.init)
//    }
//}

// MARK: -

extension MaxValue {
//    init(_ atom: Atom) {
//        switch atom {
//        case .float(let value): self = .float(value)
//        case .int(let value): self = .int(value)
//        case .symbol(let value): self = .symbol(value)
//        case .unknown: self = .unknown
//        }
//    }

    var asInt: Int? {
        if case let .int(i) = self { return i } else { return nil }
    }

    var asDouble: Double? {
        switch self {
        case .float(let f): return f
        case .int(let i): return Double(i)
        default: return nil
        }
    }

    var asString: String? {
        if case let .symbol(s) = self { return s } else { return nil }
    }
}

// MARK: - Array conversions

extension Array where Element == MaxValue {
    var asAtoms: [Atom] {
        self.map(Atom.init)
    }

    var asIntArray: [Int]? {
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

extension Array where Element == Int {
    var asMaxList: MaxList { self.map { .int($0) } }
}

extension Array where Element == Double {
    var asMaxList: MaxList { self.map { .float($0) } }
}

extension Array where Element == String {
    var asMaxList: MaxList { self.map { .symbol($0) } }
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

public extension MaxValue {
   public func convert<T: MaxValueConvertible>(to type: T.Type) -> T? {
        switch (self, type) {
        case (.int(let i), is Int.Type): return i as? T
        case (.float(let f), is Double.Type): return f as? T
        case (.int(let i), is Double.Type): return Double(i) as? T
        case (.symbol(let s), is String.Type): return s as? T
        default: return nil
        }
    }
}

extension MaxList {
    public func unpack<T1>() -> T1? where T1: MaxValueConvertible {
        guard count == 1 else { return nil }
        return self[0].convert(to: T1.self)
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

    // Add more arities as needed...
}
