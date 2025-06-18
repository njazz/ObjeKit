# ObjeKit

Swift DSL for Max SDK (Unofficial)

## 📦 Overview

This project aims to provide a compact syntax alternative to the traditional Max/MSP C API, enabling seamless integration with existing Swift codebases.

Tradeoffs:  
- Introduces an additional dynamic dispatch layer, which may have performance implications in tight DSP loops.  
- Requires explicit initialization logic to bridge Swift objects with Max/MSP's C-based runtime.  

## 🧪 Quick Start

### ✅ Installation

- add package to the project

---

### 👾 Define a Max Object

Here's a minimal example of a Max object with one inlet, one outlet, and two methods (`bang` and `int`):

```swift
import ObjeKit

final class DemoObject: MaxObject {
    @Inlet var input = 0
    @MaxState someValue = 123.45

    @MaxOutput var genericOutput

    @MaxIOBuilder
    var io: any MaxIOComponent {

	    MaxMethod() {
	        print("Received bang")
	    }

	    MaxMethod() { (value : Int) in
	        print("Received int:", value)
	    }

	    Outlet(.index(0)) { self.$someValue }
	}

    required init() {}
}

@_cdecl("ext_main")
public func ext_main(_ r: UnsafeMutableRawPointer) {
    MaxDispatcher.setup(DemoObject.self)
}
```

---

### Status

Version number: 0.0.1  
  
✅ Inlets  
🔄 Outlets  
🔄 MaxOutput - generic output  
✅ Arguments  
❌ Attributes  

❌ Tests

❌ DSP  
❌ Jitter  

---


Max and Max/MSP are trademarks of Cycling '74. This project is not affiliated with, endorsed by, or sponsored by Cycling '74.
