//
//  Inlet.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//


// === 1. Core wrapper definitions ===

/*
 
 
@propertyWrapper
struct Inlet<T> {
  let type: InletType
  let handler: (T) -> Void
  var wrappedValue: (T) -> Void { handler }

  init(_ type: InletType, wrappedValue: @escaping (T) -> Void) {
    self.type = type
    self.handler = wrappedValue
  }
}

@propertyWrapper
struct Outlet<T> {
  let type: OutletType
  // storage for the last‐sent value (or you could hook directly into the C API)
  private var last: T?
  var wrappedValue: T? {
    get { last }
    set { last = newValue }
  }

  init(_ type: OutletType) {
    self.type = type
  }

  func send(_ v: T) {
    // call outlet_* C function here...
    print("→ send \(v) on outlet of type \(type)")
  }
}

@propertyWrapper
struct Argument<T> {
  let name: String
  var wrappedValue: T
  init(_ name: String, wrappedValue: T) {
    self.name = name
    self.wrappedValue = wrappedValue
  }
}


// === 2. The MaxObject protocol ===

public protocol MaxObject: AnyObject {
  /// Should reflect all @Inlet/@Outlet/@Argument props
  /// and build a concrete object that actually wires them.
  var build: some MaxObject { get }
  
  // These get forwarded to the real object returned by `build`
  var className: String { get }
  func process()
  func cleanup()
}

// === 3. A default implementation of `build` via reflection ===

extension MaxObject {
  var build: some MaxObject {
    // 1) Mirror over self to collect wrappers
    let m = Mirror(reflecting: self)
    var fields = [MaxField]()
    var args  = [String: Any]()

    for child in m.children {
      guard let label = child.label else { continue }
      let value = child.value

      switch value {
      case let inlet as Inlet<Any>:
        fields.append(.inlet(name: label, type: inlet.type) { any in
          guard let t = any as? Any else { return }
          inlet.handler(t)
        })

      case let outlet as Outlet<Any>:
        fields.append(.outlet(name: label, type: outlet.type))

      case let arg as Argument<Any>:
        args[arg.name] = arg.wrappedValue

      default:
        break
      }
    }

    // 2) Create the real impl with name + args + fields
    struct Impl: MaxObject {
      let className: String
      let args: [String: Any]
      let fields: [MaxField]
      func process() {
        for case let .process(fn) in fields { fn() }
      }
      func cleanup() {
        for case let .cleanup(fn) in fields { fn() }
      }
    }

    // Pull className from a special @Argument("class") if you want,
    // or have each struct hardcode it:
    let cname = (args["class"] as? String) ?? "Unnamed"
    return Impl(className: cname, args: args, fields: fields)
  }
}


// === 4. Your user‐facing struct ===

struct Obj: MaxObject {
  //  - inlet that multiplies by `testArg` and sends to `out1`
  @Inlet(.int) var in1 = { value in
    out1.send(value * testArg)
  }

  //  - an integer outlet
  @Outlet(.int) var out1: Outlet<Int>

  //  - an argument with default `2`, exposed to Max as "test_arg"
  @Argument("test_arg") var testArg: Int = 2

  // must provide a name argument for the class:
  @Argument("class") var className: String = "obj"

  // `build` is synthesized by the protocol extension!
}


// === 5. Usage ===

let raw = Obj()
let maxObj: MaxObject = raw.build

print(maxObj.className)   // "obj"
maxObj.process()          // would route any incoming bangs/ints, etc.
maxObj.cleanup()          // tear‐down

// If you want to simulate an inlet call:
(raw.in1)(5)              // → send 10 on outlet of type int
 
 // -----
 
 import SwiftSyntax
 import SwiftSyntaxBuilder
 import SwiftSyntaxMacros

 /// Attribute macro to synthesize `className` property.
 @attached(peer, names: named(className))
 public macro ClassName(_ name: String) = #externalMacro(
     module: "MaxMacros",
     type: "ClassNameMacro"
 )

 /// Macro implementation in MaxMacros target
 public struct ClassNameMacro: PeerMacro {
   public static func expansion(
     of node: AttributeSyntax,
     providingPeersOf declaration: some DeclGroupSyntax,
     in context: some MacroExpansionContext
   ) throws -> [DeclSyntax] {
     // Extract the string literal argument
     guard
       let argumentClause = node.argument?.as(TupleExprElementListSyntax.self),
       let firstArg = argumentClause.first,
       let literal = firstArg.expression.as(StringLiteralExprSyntax.self)
     else {
       // Required argument missing or wrong type
       throw MacroDiagnostics.invalidArgument(node)
     }

     // Build: public var className: String { "<name>" }
     let decl = try VariableDeclSyntax("public var className: String { \(literal) }")
     return [DeclSyntax(decl)]
   }
 }

 // Usage in client code:

 @ClassName("obj")
 struct Obj: MaxObject {
   @Inlet(.int) var in1 = { value in
     out1.send(value * testArg)
   }

   @Outlet(.int) var out1: Outlet<Int>
   @Argument("test_arg") var testArg: Int = 2

   // `className` synthesized by macro; build via protocol extension
 }


*/

/*
 
 @ClassName("obj")
 struct Obj: MaxObject {
   @Inlet(.int) var in1 = { value in
     out1.send(value * testArg)
   }
   @Outlet(.int) var out1: Outlet<Int>
   @Argument("test_arg") var testArg: Int = 2
 }
 
 */
