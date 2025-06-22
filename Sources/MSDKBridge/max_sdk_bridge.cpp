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

// MARK: -

extern "C" {

void _class_add_attr_long(t_class* cls, const char* name) {
    CLASS_ATTR_LONG(cls, name, ATTR_FLAGS_NONE, t_wrapped_object, dummyAttribute.longValue);
}

void _class_add_attr_double(t_class* cls, const char* name) {
    CLASS_ATTR_DOUBLE(cls, name, ATTR_FLAGS_NONE, t_wrapped_object, dummyAttribute.doubleValue);
}

void _class_add_attr_symbol(t_class* cls, const char* name) {
    CLASS_ATTR_SYM(cls, name, ATTR_FLAGS_NONE, t_wrapped_object, dummyAttribute.symbolValue);
}

void _class_attr_label(t_class* cls, const char* name, const char* label) {
    CLASS_ATTR_LABEL(cls, name, ATTR_FLAGS_NONE, label);
}

void _class_attr_save(t_class* cls, const char* name, const bool v){
    v ? CLASS_ATTR_SAVE(cls, name, ATTR_FLAGS_NONE) : CLASS_ATTR_DONTSAVE(cls, name, ATTR_FLAGS_NONE);
}

void _class_attr_accessors(t_class* cls, const char* name, _attr_getter getter, _attr_setter setter){
    CLASS_ATTR_ACCESSORS(cls, name, getter, setter);
}


}

// MARK: -

extern "C" {

// C function to get the next function pointer (rotating)
method_ctor get_next_ctor(method_ctor ctor) {
    _wrapperTarget = (method_ctor)ctor;
    
    method_ctor f = ptrs[currentIndex];
    currentIndex = (currentIndex + 1); //% NumWrappers;
    if (currentIndex>= NumWrappers) return nil;
    return f;
}

} // extern "C"
