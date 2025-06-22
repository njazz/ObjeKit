//
//  Atom.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//

@_implementationOnly import MSDKBridge

/// Low-level Max SDK type wrap
///
/// Supported types: float, int, symbol
enum Atom {
    case float(Double)
    case int(Int)
    case symbol(String)
    case unknown

    init(_ ptr: UnsafeMutablePointer<t_atom>) {
        let type = UInt32(atom_gettype(ptr))

        switch type {
        case A_FLOAT.rawValue:
            self = .float(Double(atom_getfloat(ptr)))
        case A_LONG.rawValue:
            self = .int(Int(atom_getlong(ptr)))
        case A_SYM.rawValue:
            let symbol = atom_getsym(ptr)
            self = .symbol(String(cString: symbol!.pointee.s_name))
        default:
            self = .unknown
        }
    }
}

// MARK: -

extension Atom {
    init(_ maxValue: MaxValue) {
        switch maxValue {
        case let .float(value):
            self = .float(value)
        case let .int(value):
            self = .int(value)
        case let .symbol(value):
            self = .symbol(value)
        case .unknown:
            self = .unknown
        }
    }
}

extension Atom: Equatable {
    public static func == (lhs: Atom, rhs: Atom) -> Bool {
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

extension Array where Element == Atom {
    var asMaxList: MaxList {
        map(MaxValue.init)
    }
}

// MARK: - C interop

/// Convert Atom List from C API argc, argv
func atomsFromPointer(_ count: CLong, _ ptr: UnsafeMutablePointer<t_atom>?) -> [Atom] {
    guard let ptr = ptr else { return [] }
    return (0 ..< count).map { i in
        Atom(ptr.advanced(by: Int(i)))
    }
}

/// Convert Array of Atoms to C API argc, argv
func makeAtomPointer(from atoms: [Atom]) -> (argc: CLong, argv: UnsafeMutablePointer<t_atom>) {
    let argc = CLong(atoms.count)
    let argv = UnsafeMutablePointer<t_atom>.allocate(capacity: atoms.count)

    for (i, atom) in atoms.enumerated() {
        let ptr = argv.advanced(by: i)
        switch atom {
        case let .float(f):
            atom_setfloat(ptr, Double(f))
        case let .int(i):
            atom_setlong(ptr, CLong(i))
        case let .symbol(s):
            let cstr = strdup(s) // assume strdup is fine; Max will likely manage it if atom_setsym stores it
            atom_setsym(ptr, gensym(cstr))
        case .unknown:
            // no-op or set as blank symbol
            atom_setsym(ptr, gensym(""))
        }
    }

    return (argc, argv)
}
