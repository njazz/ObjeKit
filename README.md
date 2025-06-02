# ObjeKit

Swift DSL for Max SDK (Unofficial)

## Overview

This project provides a minimal, declarative Swift framework for authoring Max/MSP external objects. It leverages Swift’s modern language features—such as property wrappers, result builders, and reflection—to define Max object components (inlets, outlets, and methods) with minimal boilerplate.

By prioritizing native macOS interop and Swift’s type system, the framework offers a compact, expressive API for Max external development. The tradeoff is limited cross-platform portability, as the implementation is closely tied to the Max SDK and Apple's platform constraints.

This approach is intended for developers who value concise syntax and native Swift tooling over C-level compatibility or multi-platform deployment.

## 🧪 Quick Start

### ✅ Prerequisites

- macOS with Xcode  
- Max SDK (bridged to Swift via module map or wrapper)  
- Swift package or Xcode project integrating this framework  

---

### 👾 Define a Max Object

Here's a minimal example of a Max object with one inlet, one outlet, and two methods (`bang` and `int`):

```swift
import ObjeKit

final class DemoObject: MaxObject {
    @Inlet var input = 0
    @MaxState someValue = 123.45

    @MaxIOBuilder
    var io: any MaxIOComponent {

	    MaxMethod() {
	        print("Received bang")
	    }

	    MaxMethod() { (value : Int) in
	        print("Received int:", value)
	    }

	    Outlet(0) { self.$someValue }
	}

    required init() {}
}

@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
    MaxDispatcher.setup(DemoObject.self)
}
```
