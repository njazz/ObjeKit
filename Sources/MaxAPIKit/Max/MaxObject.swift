//
//  MaxObject.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//


public protocol MaxObject : AnyObject{
    var className : String { get }
    
  func process()

  func cleanup()
}
