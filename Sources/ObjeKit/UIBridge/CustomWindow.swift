//
//  ObjectWindow.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 22/06/2025.
//

import SwiftUI
import AppKit

public class CustomWindow<Content: View> {
    private var window: NSWindow? = nil
    private let title: String
    private let content: () -> Content

    public init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    public func showWindow() {
        if window == nil {
            let hostingController = NSHostingController(rootView: content())
            let newWindow = NSWindow(contentViewController: hostingController)
            newWindow.title = title
            newWindow.setContentSize(NSSize(width: 300, height: 200))
            newWindow.styleMask.insert([.titled, .closable, .resizable])
            self.window = newWindow
        }
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    public func hideWindow() {
        window?.orderOut(nil)
    }

}
