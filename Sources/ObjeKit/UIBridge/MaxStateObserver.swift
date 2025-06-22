//
//  MaxStateObserver.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 22/06/2025.
//

import Combine
import Foundation

extension Double {
    func isApproximatelyEqual(to other: Double, epsilon: Double = 1e-10) -> Bool {
        abs(self - other) < epsilon
    }
}

func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}

// MARK: -

/// ObservableObject wrapper for MaxBinding
public final class MaxStateObserver<T: Equatable>: ObservableObject {
    @Published public var value: T

    private var maxBinding: MaxBinding<T>
    private var cancellables = Set<AnyCancellable>()

    public init(_ maxBinding: MaxBinding<T>) {
        self.maxBinding = maxBinding
        value = maxBinding.get()

        // Observe changes via MaxBinding
        maxBinding.observe { [weak self] newValue in
            runOnMainThread {
                guard let self = self else { return }

                if let old = self.value as? Double, let new = newValue as? Double {
                    if !old.isApproximatelyEqual(to: new) {
                        self.value = newValue
                    }
                } else {
                    if self.value != newValue {
                        self.value = newValue
                    }
                }
            }
        }

        // Sync back from SwiftUI -> MaxBinding
        $value
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if self.maxBinding.get() != newValue {
                    self.maxBinding.set(newValue)
                }
            }
            .store(in: &cancellables)
    }
}
