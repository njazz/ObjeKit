//
//  UIExtensions.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 22/06/2025.
//

import SwiftUI

extension MaxBinding {
    public var swiftUIBinding: Binding<T> {
        Binding(get: get, set: set)
    }
}
