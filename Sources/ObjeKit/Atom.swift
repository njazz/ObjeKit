//
//  Atom.swift
//  ObjeKit
//
//  Created by alex on 25/05/2025.
//

@_implementationOnly import MaxSDKBridge

// minimal
public enum MaxValue {
    case int(Int)
    case float(Double)
    case symbol(String)
    case unknown
}

public typealias MaxList = [MaxValue]

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

extension Atom {
    init(_ maxValue: MaxValue) {
        switch maxValue {
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

// MARK: -

extension Array where Element == Atom {
    var asMaxList: MaxList {
        self.map(MaxValue.init)
    }
}

extension Array where Element == MaxValue {
    var asAtoms: [Atom] {
        self.map(Atom.init)
    }
}

// MARK: -

func atomsFromPointer(_ count: CLong, _ ptr: UnsafeMutablePointer<t_atom>?) -> [Atom] {
    guard let ptr = ptr else { return [] }
    return (0..<count).map { i in
        Atom(ptr.advanced(by: Int(i)))
    }
}

func makeAtomPointer(from atoms: [Atom]) -> (argc: CLong, argv: UnsafeMutablePointer<t_atom>) {
    let argc = CLong(atoms.count)
    let argv = UnsafeMutablePointer<t_atom>.allocate(capacity: atoms.count)

    for (i, atom) in atoms.enumerated() {
        let ptr = argv.advanced(by: i)
        switch atom {
        case .float(let f):
            atom_setfloat(ptr, Double(f))
        case .int(let i):
            atom_setlong(ptr, CLong(i))
        case .symbol(let s):
            let cstr = strdup(s) // assume strdup is fine; Max will likely manage it if atom_setsym stores it
            atom_setsym(ptr, gensym(cstr))
        case .unknown:
            // no-op or set as blank symbol
            atom_setsym(ptr, gensym(""))
        }
    }

    return (argc, argv)
}
