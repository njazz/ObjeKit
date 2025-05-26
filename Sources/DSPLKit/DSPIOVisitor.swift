//
//  MaxIOVisitor.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//


public protocol DSPIOVisitor  {
    func visit(_ inlet: AudioIn)
    func visit(_ outlet: AudioOut)

}
