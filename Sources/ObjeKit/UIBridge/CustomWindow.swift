//
//  ObjectWindow.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 22/06/2025.
//

import AppKit
import SwiftUI

/// Create a window with title and SwiftUI View inside.
///
/// NB show/hide calls are thread-safe
public class CustomWindow<Content: View> {
    private var window: NSWindow?
    private let title: String
    private let content: () -> Content

    public init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    public func showWindow() {
        runOnMainThread {
            if self.window == nil {
                let hostingController = NSHostingController(rootView: self.content())
                let newWindow = NSWindow(contentViewController: hostingController)
                newWindow.title = self.title
                newWindow.setContentSize(NSSize(width: 300, height: 200))
                newWindow.styleMask.insert([.titled, .closable, .resizable])
                self.window = newWindow
            }
            self.window?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    public func hideWindow() {
        runOnMainThread {
            self.window?.orderOut(nil)
        }
    }
}
