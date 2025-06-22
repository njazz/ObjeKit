//
//  Untitled.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//

///
/*

 //CLASS_ATTR_ACCESSORS(, , , )

 attribute type:

 string/symbol
 long/int
 float32
 double
 atom

 arrays of these 5

 NB: save in patcher / transitional  CLASS_ATTR_SAVE

 NB attr style:

 <ul>
      <li>"text"      : a text editor</li>
     <li>"onoff"     : a toggle switch</li>
     <li>"rgba"      : a color chooser</li>
     <li>"enum"      : a menu of available choices, whose symbol will be passed upon selection</li>
     <li>"enumindex" : a menu of available choices, whose index will be passed upon selection</li>
     <li>"rect"      : a style for displaying and editing #t_rect values</li>
     <li>"font"      : a font chooser</li>
     <li>"file"      : a file chooser dialog</li>
 </ul>

 CLASS_ATTR_LABEL

 later: attr categories wrapper

 */

protocol MaxAttributeValueElement {}

extension Int: MaxAttributeValueElement {}
extension UInt: MaxAttributeValueElement {}
extension Double: MaxAttributeValueElement {}
extension Float: MaxAttributeValueElement {}
extension String: MaxAttributeValueElement {}

extension MaxValue: MaxAttributeValueElement {}

public protocol MaxAttributeValue {}

extension Int: MaxAttributeValue {}
extension UInt: MaxAttributeValue {}
extension Double: MaxAttributeValue {}
extension Float: MaxAttributeValue {}
extension String: MaxAttributeValue {}

extension Array: MaxAttributeValue where Element: MaxAttributeValueElement {}

// MARK: -

/// Max Attribute style enum
public enum AttributeStyle: CaseIterable, RawRepresentable {
    case m_text, m_onoff, m_rgba, m_enum, m_enumindex, m_rect, m_font, m_file

    public init?(rawValue: String) {
        let caseName = "m_\(rawValue)"
        if let value = AttributeStyle.allCases.first(where: { "\($0)" == caseName }) {
            self = value
        } else {
            return nil
        }
    }

    public var rawValue: String {
        let fullName = String(describing: self)
        guard fullName.hasPrefix("m_") else { return fullName }
        return String(fullName.dropFirst(2))
    }
}

// MARK: -

/// Max Attribute wrapper (R/W)
///
/// Parameter style: display style in Inspector
/// Parameter label: label in Inspector, optional
/// Parameter name: name to be used within object & Inspector
/// Parameter transitional: if true, value is not stored within Max patch
@propertyWrapper
public class Attribute<T: MaxAttributeValue>: MaxIOComponent {
    
    var style: AttributeStyle = .m_text
    var label: String? /// use full name if nil
    var name: String
    var transitional: Bool = false

    private var binding: MaxBinding<T>

    public var onChange: ((T) -> Void)?

    public var wrappedValue: T {
        get { binding.get() }
        set {
            binding.set(newValue)
            if let c = onChange { c(newValue) }
        }
    }

    public init(_ name: String, style: AttributeStyle = .m_text, label: String? = nil, transitional: Bool = false, _ bindingProvider: @escaping () -> MaxBinding<T>) {
        self.name = name
        self.style = style
        self.label = label
        self.transitional = transitional
        
        binding = bindingProvider()

        binding.observe { newValue in
            self.onChange?(newValue)
        }
    }

    public func accept<V>(visitor: V) where V: MaxClassIOVisitor {
        visitor.visit(self)
    }
}
