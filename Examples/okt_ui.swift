//
//  okt_ui.swift
//  ObjeKitTest
//
//  Created by alex on 22/06/2025.
//

import ObjeKit
import SwiftUI

struct ObjectUI: View {
    @Binding var floatValue : Double
    
    var body: some View {
        VStack() {
            Text("Test Object UI")
                .padding()
            Slider(value:_floatValue, label: { Text("Value") })
        }
    }
}

extension MaxBinding {
    public var swiftUIBinding: Binding<T> {
        Binding(get: get, set: set)
    }
}

// MARK: -

class ObjectWindow {
    private var window: NSWindow? = nil
    
    @Binding var floatValue : Double

    func showWindow() {
        if window == nil {
            let contentView = ObjectUI(floatValue: self._floatValue)
            let hostingController = NSHostingController(rootView: contentView)
            window = NSWindow(contentViewController: hostingController)
            window?.title = "SwiftUI Window"
            window?.setContentSize(NSSize(width: 300, height: 200))
            window?.styleMask.insert([.titled, .closable, .resizable])
        }
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func hideWindow() {
        window?.orderOut(nil)
    }

    func toggleWindow() {
        if window?.isVisible == true {
            hideWindow()
        } else {
            showWindow()
        }
    }
    
    init(floatValue: Binding<Double>) {
        self._floatValue = floatValue
    }
}

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
    
    lazy var window: ObjectWindow = ObjectWindow(floatValue: $floatValue.swiftUIBinding)
    
    @MaxState
    var intValue: CLong = 0
    
    @MaxState
    var floatValue: Double = 0
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        Inlet(name:"show") { DispatchQueue.main.async {
            self.window.showWindow()
        }}
        Inlet(name:"hide") { DispatchQueue.main.async {
            self.window.hideWindow()
        }}
        
        Inlet() { (v:CLong) in
            DispatchQueue.main.async { (v>0) ? self.window.showWindow() : self.window.hideWindow() }
        }
        
        Inlet() { (v:Double) in DispatchQueue.main.async { self.floatValue = v } }
        
        Outlet() { self.$intValue }
        Outlet() { self.$floatValue }
    }
}
