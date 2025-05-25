//
//  max_api_kit.h
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//

#include "ext.h"
#include "ext_obex.h"
#include "ext_common.h"

//static t_symbol* _CLASS_BOX = CLASS_BOX;

static inline t_class* _class_new_basic(const char* name, method init, method free, size_t size) {
   return class_new(name, init, free, size, NULL, 0);
}
