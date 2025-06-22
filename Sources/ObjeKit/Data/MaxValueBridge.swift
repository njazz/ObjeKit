//
//  AtomBridge.swift
//  ObjeKit
//
//  Created by alex on 22/06/2025.
//

@_implementationOnly import MSDKBridge

extension MaxValue {
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

// MARK: - C interop

/// Convert Atom List from C API argc, argv
func atomsFromPointer(_ count: CLong, _ ptr: UnsafeMutablePointer<t_atom>?) -> [MaxValue] {
    guard let ptr = ptr else { return [] }
    return (0 ..< count).map { i in
        MaxValue(ptr.advanced(by: Int(i)))
    }
}

/// Convert Array of Atoms to C API argc, argv
func makeAtomPointer(from atoms: [MaxValue]) -> (argc: CLong, argv: UnsafeMutablePointer<t_atom>) {
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
