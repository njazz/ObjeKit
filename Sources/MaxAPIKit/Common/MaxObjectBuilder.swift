//
//  MaxIOBuilder.swift
//  MaxAPIKit
//
//  Created by alex on 26/05/2025.
//


@resultBuilder
public struct MaxObjectBuilder {
    public static func buildBlock(_ components: MaxObject...) -> MaxObject {
        // If only one component, return it directly
        if components.count == 1 {
            return components[0]
        }
        // Otherwise, wrap multiple components into a composite container
        return CompositeMaxObject(components)
    }

    // Optional: support for optional components
    public static func buildOptional(_ component: MaxObject?) -> MaxObject {
        return component ?? CompositeMaxObject([])
    }

    // Optional: support for if-else inside the builder
    public static func buildEither(first component: MaxObject) -> MaxObject {
        return component
    }

    public static func buildEither(second component: MaxObject) -> MaxObject {
        return component
    }

    // Optional: support for arrays of components (e.g. loops)
    public static func buildArray(_ components: [MaxObject]) -> MaxObject {
        CompositeMaxObject(components)
    }
}

// MARK: -

@resultBuilder
public struct MaxIOBuilder {
    public static func buildBlock(_ components: MaxIOComponent...) -> MaxIOComponent {
        CompositeMaxIO(components)
    }
}
