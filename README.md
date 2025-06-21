# ObjeKit

Swift DSL for Max SDK (**Unofficial**)

![WIP](https://img.shields.io/badge/status-WIP-yellow.svg)
![Swift Version](https://img.shields.io/badge/swift-5.9-orange.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%2011%2B-lightgrey.svg)
![Build Status](https://github.com/njazz/ObjeKit/actions/workflows/build.yml/badge.svg)

## 📦 Overview

This project defines a compact syntax layer for integrating Swift with the Max/MSP C API. It enables the development of Max external objects using Swift by providing a structured interface that maps Swift constructs to Max’s runtime model.

Applications:

- Rapid prototyping of Max objects within an existing Swift codebase.
- Reuse of Swift logic or libraries in Max/MSP externals without translating to C.

Trade-offs:

- Introduces a dynamic dispatch layer between Swift and the Max API, which may impact performance in real-time signal processing (DSP) paths.
- Requires explicit initialization to bridge Swift memory management and object lifecycles with Max’s C-based runtime.
## 🧪 Quick Start

### ✅ Installation

- add package to the project

- see Examples folder for some demos

---

### 👾 Define a Max Object

Here's a minimal example of a Max object with one inlet, one outlet showing basic functionality:

```swift
import ObjeKit

class ObjeKitTest_Simple : MaxObject {
    static var className: String { "okt_simple"}
    
    required init() {
        MaxRuntime.post("init: okt_simple")
    }
    
    deinit {
        MaxRuntime.post("deinit: okt_simple")
    }
    
    // MARK: - state objects
    
    @MaxState
    var floatValue : Double = 0
    
    @MaxState
    var intValue : CLong = 0
    
    @MaxState
    var listValue : MaxList = []
    
    @MaxOutput()
    var directOutlet
    
    @MaxIOBuilder
    var io: any MaxIOComponent {
        
        // MARK: - builder:  methods
        
        Inlet() {
            self.floatValue += 1
            MaxRuntime.post("bang! incremented value: \(self.floatValue)")
        }
        
        Inlet() { (value : Double) in
            self.floatValue = value
            MaxRuntime.post("float: \(value)")
        }
        
        Inlet() { (value : CLong) in
            self.intValue = value
            MaxRuntime.post("int: \(value)")
        }
        
        Inlet(name:"method_one")
        {
            MaxRuntime.post("method_one called")
            self.directOutlet.bang()
        }
                
        Inlet(name:"method_any") { value in
            MaxRuntime.post("method_any called with value: \(value)")
            self.listValue = value
        }
        
        Inlet() { (value:[MaxValue]) in
            MaxRuntime.post("received list: \(value)")
        }
        
        // MARK: - builder:  Outlets
        Outlet(.index(0)) { self.$floatValue }
        Outlet { self.$intValue }
        Outlet { self.$listValue }
    }
    
}


@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
    MaxDispatcher.setup(ObjeKitTest_Simple.self)
}
```

---

### Status

⚠️ **Work In Progress** — This project is currently experimental and not ready for production use.

Version number: 0.0.1 - Proof of concept
  
✅ Inlets  
🔄 Outlets  
🔄 MaxOutput - generic output  
✅ Arguments  
❌ Attributes  

🔄 Tests

❌ DSP  
❌ Jitter  

---


Max and Max/MSP are trademarks of Cycling '74. This project is not affiliated with, endorsed by, or sponsored by Cycling '74.
