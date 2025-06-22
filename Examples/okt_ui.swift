//
//  okt_ui.swift
//  ObjeKitTest
//
//  Created by alex on 22/06/2025.
//

import ObjeKit
import SwiftUI

struct ObjectUI: View {
    @ObservedObject var floatValue : MaxStateObserver<Double>
    
    var body: some View {
        VStack() {
            Text("Test Object UI")
                .padding()
            Slider(value:$floatValue.value, label: { Text("Value") })
        }.padding()
    }
}

// MARK: -

func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}


// MARK: -

@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
    MaxDispatcher.setup(ObjeKitTest_Attributes.self)
}

/// small class to display window
class ObjeKitTest_Attributes : MaxObject {
    static var className: String { "okt_ui"}
    
    required init() {
        MaxRuntime.post("init: okt_ui")
    }
    
    deinit {
        MaxRuntime.post("deinit: okt_ui")
    }
    
    lazy var window = CustomWindow("Test Window") { ObjectUI(floatValue: MaxStateObserver(self.$floatValue) ) } //: TestObjectWindow = TestObjectWindow(floatValue: $floatValue.swiftUIBinding)
    
    @MaxState
    var intValue: CLong = 0
    
    @MaxState
    var floatValue: Double = 0
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        Inlet(name:"show") { runOnMainThread {
            self.window.showWindow()
        }}
        Inlet(name:"hide") { runOnMainThread {
            self.window.hideWindow()
        }}
        
        Inlet() { (v:CLong) in
            runOnMainThread { (v>0) ? self.window.showWindow() : self.window.hideWindow() }
        }
        
        Inlet() { (v:Double) in DispatchQueue.main.async { self.floatValue = v } }
        
        Outlet() { self.$intValue }
        Outlet() { self.$floatValue }
    }
}
