//
//  CtorWrap.cpp
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//

#include "max_sdk_bridge.h"

#include <iostream>
#include <array>

// MARK: - function pointer wrappers

thread_local method_ctor _wrapperTarget {nullptr};

template <int N>
struct Wrapper {
    // NB
    static void* call(void* v,/* t_symbol* s, */long argc, t_atom* argv) {
        return _wrapperTarget ? _wrapperTarget((void*)&Wrapper::call,/*s,*/argc,argv) : nullptr ;
    }
    
};

constexpr int NumWrappers = 64;

// Generate array of wrapper function pointers
template <int... Ns>
constexpr auto makePtrArray(std::integer_sequence<int, Ns...>) {
    return std::array<method_ctor, sizeof...(Ns)>{ &Wrapper<Ns>::call... };
}

constexpr thread_local auto ptrs = makePtrArray(std::make_integer_sequence<int, NumWrappers>{});

static int currentIndex = 0;

extern "C" {

// C function to get the next function pointer (rotating)
method_ctor get_next_ctor(method_ctor ctor) {
    _wrapperTarget = (method_ctor)ctor;
    
    method_ctor f = ptrs[currentIndex];
    currentIndex = (currentIndex + 1); //% NumWrappers;
    if (currentIndex>= NumWrappers) return nil;
    return f;
}

// MARK: -

} // extern "C"
