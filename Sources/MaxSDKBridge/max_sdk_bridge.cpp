//
//  CtorWrap.cpp
//  ObjeKit
//
//  Created by alex on 25/05/2025.
//

#include "max_sdk_bridge.h"

#include <iostream>
#include <array>

thread_local method _wrapperTarget {nullptr};

template <int N>
struct Wrapper {
    static void* call(void* v) {
        
        return _wrapperTarget ? _wrapperTarget((void*)&Wrapper::call) : nullptr ;
    }
    
    
};

constexpr int NumWrappers = 64;

// Generate array of wrapper function pointers
template <int... Ns>
constexpr auto makePtrArray(std::integer_sequence<int, Ns...>) {
    return std::array<method, sizeof...(Ns)>{ &Wrapper<Ns>::call... };
}

constexpr thread_local auto ptrs = makePtrArray(std::make_integer_sequence<int, NumWrappers>{});

static int currentIndex = 0;

extern "C" {

// C function to get the next function pointer (rotating)
method get_next_ctor(method ctor) {
    _wrapperTarget = ctor;
    
    method f = ptrs[currentIndex];
    currentIndex = (currentIndex + 1); //% NumWrappers;
    if (currentIndex>= NumWrappers) return nil;
    return f;
}

} // extern "C"
