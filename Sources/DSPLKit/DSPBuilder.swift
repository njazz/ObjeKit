//
//  DSPBuilder.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//

@resultBuilder
public enum DSPBuilder {
    public static func buildBlock(_ component: DSPObject) -> DSPObject {
        component
    }
}
