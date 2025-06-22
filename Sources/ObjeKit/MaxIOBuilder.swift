//
//  MaxIOBuilder.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//


/// Builder class for MaxObject components
@resultBuilder
public struct MaxIOBuilder {
    public static func buildBlock(_ components: MaxIOComponent...) -> MaxIOComponent {
        CompositeMaxIO(components)
    }
}
