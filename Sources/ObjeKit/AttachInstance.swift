//
//  MaxObjectAttach.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//
// @_implementationOnly import MSDKBridge

@_implementationOnly import MSDKBridge

/// Attach DispatcherClass instance to MaxObject instance
///
/// Connects Inlet(), Outlet(), Argument() to DispatcherClass
class AttachInstance: MaxIOVisitor {
    var object: UnsafeMutablePointer<t_object>
    var wrapper: DispatcherClass

    var currentArgumentIndex: UInt = 0
    var currentArgumentIsOptional = false

    init(_ object: UnsafeMutablePointer<t_object>, wrapper: DispatcherClass) {
        self.object = object
        self.wrapper = wrapper
    }

    // MARK: -

    func visit(_ inlet: Inlet) {
        MaxLogger.shared.post("\(object) : Registering method \(inlet.kind) port: \(inlet.index)")

        switch inlet.kind {
        case .bang:
            wrapper.onBang = inlet.callAsBang
        case .int:
            wrapper.onInt = inlet.callAsInt
        case .float:
            wrapper.onDouble = inlet.callAsFloat
        case let .selector(name):
            wrapper.onSelector[name] = inlet.callAsSelector
        case .list:
            wrapper.onList = inlet.callAsSelector
        }

        // add inlets accordingly
        if case .available = inlet.index {
            let this_inlet = inlet_new(self.object, nil)
            if this_inlet != nil { wrapper.inlets.append(this_inlet!) }
            MaxLogger.shared.post("added next inlet")
        }

//        if case let .index(x) = inlet.index {
//            if (wrapper.inlets.count == 0) {
//                let this_inlet = inlet_new(self.object, nil)
//                if this_inlet != nil { wrapper.inlets.append(this_inlet!) }
//                MaxRuntime.post("added inlet");
//            }
//        }
    }

    func visit<T>(_ outlet: Outlet<T>) {
        MaxLogger.shared.post("\(object) : Registering outlet with value: \(outlet.wrappedValue) port: \(outlet.index)")

        // TODO: cleanup
        if case .available = outlet.index {
            let this_outlet = outlet_new(self.object, nil)
            if this_outlet != nil { wrapper.outlets.append(this_outlet!) }

            //
            outlet.onChange = { [this_outlet] value in

                if T.Type.self == MaxList.self {
                    let v = value as? MaxList
                    if v?.count == 0 {
                        MaxLogger.shared.post("outlet bang")
                        outlet_bang(this_outlet)
                    } else {
                        let atoms = makeAtomPointer(from: v!)
                        outlet_list(this_outlet, nil, Int16(atoms.argc), atoms.argv)
                        // NB list size is limited to 256
                        MaxLogger.shared.post("outlet list \(value) -> \(v) -> \(atoms)")
                    }
                }
            }
        }

        if case let .index(x) = outlet.index {
            if wrapper.outlets.count == 0 {
                MaxLogger.shared.post("adding outlet")
                let this_outlet = outlet_new(self.object, nil)
                if this_outlet != nil { wrapper.outlets.append(this_outlet!) }
            }
        }

        if case let .index(x) = outlet.index {
            let this_outlet = wrapper.outlets[x]
            MaxLogger.shared.post("attaching")

            outlet.onChange = { [this_outlet] value in
                MaxLogger.shared.post("onchange \(T.Type.self)")
                if let v = value as? MaxList {
                    if v.count == 0 {
                        MaxLogger.shared.post("outlet bang")
                        outlet_bang(this_outlet)
                    } else {
                        let atoms = makeAtomPointer(from: v)
                        outlet_list(this_outlet, nil, Int16(atoms.argc), atoms.argv)
                        // NB list size is limited to 256
                        MaxLogger.shared.post("outlet list \(atoms)")
                    }
                }

                if let v = value as? CLong {
                    outlet_int(this_outlet, v)
                }

                if let v = value as? Double {
                    outlet_float(this_outlet, v)
                }
            }
        }
    }

    // MARK: -

    func visit<T: MaxValueConvertible>(_ argument: Argument<T>) -> Bool {
        MaxLogger.shared.post("\(object) : Registering \(argument.optional ? "optional " : "")argument at \(currentArgumentIndex) \(argument.description != nil ? "(\(argument.description!))" : "")")

        if !argument.optional && currentArgumentIsOptional {
            MaxRuntime.warning("\(object) : Non-optional argument at index \(currentArgumentIndex) following optional one")
        }

        if !currentArgumentIsOptional && argument.optional { currentArgumentIsOptional = true }

        let untypedSetter = { (v: MaxValue) in

            let value = v.convert(to: T.self)

            if value == nil {
                MaxRuntime.error("\(self.object) : bad argument value provided, expected: \(T.self)")
                return false
            }

            argument.setter(value!)
            return true
        }

        wrapper.arguments.append(
            ArgumentData(untypedSetter: untypedSetter,
                         optional: argument.optional,
                         description: argument.description)
        )
        currentArgumentIndex += 1

        if !currentArgumentIsOptional {
            wrapper.requiredArguments += 1
        }

        MaxLogger.shared.post("...done")

        return true
    }
}
