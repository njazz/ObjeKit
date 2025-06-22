//
//  max_api_kit.h
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//

#ifdef __cplusplus
extern "C" {
#endif

#include "ext.h"
#include "ext_obex.h"
#include "ext_common.h"

typedef void*(*method_with_args)(void*,/*t_symbol*, */ long, t_atom*)  ;
typedef method_with_args method_ctor;
method_ctor get_next_ctor(method_ctor ctor);

#ifdef __cplusplus
}
#endif

// MARK: -

typedef struct t_wrapped_object {
    t_object m_obj;
    long m_in;
    void* m_proxy;
    
    void* box;
    
    union {
        long longValue;
        double doubleValue;
        t_symbol* symbolValue;
    } dummyAttribute;
    
} t_wrapped_object;

static inline size_t t_wrapped_object_size() { return sizeof(t_wrapped_object); }

void t_wrapped_object_allocate_proxy(t_wrapped_object* x) { x->m_proxy = proxy_new((t_object *)x, 1, &x->m_in); }
void t_wrapped_object_free_proxy(t_wrapped_object* x) { proxy_delete(x->m_proxy); }

// MARK: -

static inline t_class* _class_new_basic(const char* name, method_ctor init, method free, size_t size) {
   return class_new(name, (method)init, free, size, NULL, A_GIMME, 0);   // A_GIMME, 0
}

// MARK: -

typedef void(* _bang_method)(void*) ;
typedef void(* _int_method)(void*, long) ;
typedef void(* _float_method)(void*, double) ;
typedef void(* _full_method)(void*, t_symbol*, long argc, t_atom* argv);

static inline void _class_add_method(t_class* t, const method m, const char* name) {
    class_addmethod(t, m, name, A_GIMME, 0);
}

static inline void _class_add_bang_method(t_class* t, const _bang_method m, const char* name) {
    class_addmethod(t, (method)m, name, A_GIMME, 0);
}

static inline void _class_add_int_method(t_class* t, const _int_method m, const char* name ){
    class_addmethod(t, (method)m, name, A_LONG, 0);
}

static inline void _class_add_float_method(t_class* t, const _float_method m, const char* name ){
    class_addmethod(t, (method)m, name, A_FLOAT, 0);
}

static inline void _class_add_full_method(t_class* t, const _full_method m, const char* name ){
    class_addmethod(t, (method)m, name, A_GIMME, 0);
}

static inline t_symbol* class_box() { return CLASS_BOX; }

// MARK: -

static inline
void _error(const char* str){
    error("%s\n", str);
}

static inline
void _warning(const char* str){
    object_warn(0, "%s\n", str);
}

// MARK: -

#ifdef __cplusplus
extern "C" {
#endif

void _class_add_attr_long(t_class* cls, const char* name);
void _class_add_attr_double(t_class* cls, const char* name);
void _class_add_attr_symbol(t_class* cls, const char* name);

void _class_attr_label(t_class* cls, const char* name, const char* label);
void _class_attr_save(t_class* cls, const char* name, const bool v);

#ifdef __cplusplus
}
#endif
