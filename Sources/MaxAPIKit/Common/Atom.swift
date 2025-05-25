//
//  Atom.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//

//import MaxSDKBridge
//
//public enum Atom {
//    case float(Double)
//    case int(Int)
//    case symbol(String)
//    case unknown
//
//    public init(_ ptr: UnsafePointer<t_atom>) {
//        let type = UInt32(atom_gettype(ptr))
//        
//        switch type {
//        case A_FLOAT.rawValue:
//            self = .float(Double(atom_getfloat(ptr)))
//        case A_LONG.rawValue:
//            self = .int(Int(atom_getlong(ptr)))
//        case A_SYM.rawValue:
//            let symbol = atom_getsym(ptr)
//            self = .symbol(String(cString: symbol!.pointee.s_name))
//        default:
//            self = .unknown
//        }
//    }
//}
