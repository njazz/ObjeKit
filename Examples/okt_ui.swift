//
//  okt_ui.swift
//  ObjeKitTest
//
//  Created by alex on 22/06/2025.
//

import ObjeKit
import SwiftUI

struct ObjectUI: View {
    @ObservedObject var floatValue: MaxStateObserver<Double>
    @ObservedObject var intValue: MaxStateObserver<CLong>
    
    var sliderBinding: Binding<Double> {
        Binding<Double>(
            get: { Double(intValue.value) },
            set: { intValue.value = Int($0.rounded()) } // round or floor depending on needs
        )
    }

    var body: some View {
        VStack {
            Text("Test Object UI")
                .padding()
            Slider(value: $floatValue.value, in: 0...10, label: { Text("Float Value") }, minimumValueLabel: { Text("0") }, maximumValueLabel: { Text("10") })
            Slider(value: sliderBinding, in: 0...127, label: { Text("Int Value") }, minimumValueLabel: { Text("0") }, maximumValueLabel: { Text("127") } )
            
        }.padding()
    }
}

// MARK: -

@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
    MaxDispatcher.setup(ObjeKitTest_Attributes.self)
}

/// small class to display window
class ObjeKitTest_Attributes: MaxObject {
    static var className: String { "okt_ui" }

    required init() {
        MaxRuntime.post("init: okt_ui")
    }

    deinit {
        MaxRuntime.post("deinit: okt_ui")
    }

    lazy var window = CustomWindow("Test Window") { ObjectUI(floatValue: MaxStateObserver(self.$floatValue),
                                                             intValue: MaxStateObserver(self.$intValue)) }

    @MaxState
    var intValue: CLong = 0

    @MaxState
    var floatValue: Double = 0

    @MaxIOBuilder
    var io: any MaxIOComponent {
        Inlet(name: "show") { self.window.showWindow() }
        Inlet(name: "hide") { self.window.hideWindow() }

        Inlet { (v: CLong) in (v > 0) ? self.window.showWindow() : self.window.hideWindow() }

        Inlet { (v: Double) in self.floatValue = v }

        Outlet { self.$intValue }
        Outlet { self.$floatValue }
    }
}
