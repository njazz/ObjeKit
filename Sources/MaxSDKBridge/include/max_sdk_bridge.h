//
//  max_api_kit.h
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//



//static t_symbol* _CLASS_BOX = CLASS_BOX;
#ifdef __cplusplus
extern "C" {
#endif

#include "ext.h"
#include "ext_obex.h"
#include "ext_common.h"

method get_next_ctor(method ctor);

#ifdef __cplusplus
}
#endif

// MARK: -

typedef struct t_wrapped_object {
    t_object maxObject;
    void* box;
    
} t_wrapped_object;

static inline size_t t_wrapped_object_size() { return sizeof(t_wrapped_object); }

static inline t_class* _class_new_basic(const char* name, method init, method free, size_t size) {
   return class_new(name, init, free, size, NULL, 0);
}

static inline t_symbol* class_box() { return CLASS_BOX; }
