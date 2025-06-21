//
//  test_mocks.c
//  ObjeKit
//
//  Created by Alex Nadzharov on 19/06/2025.
//

#include "ext.h"
#include "ext_obex.h"
#include "ext_common.h"

t_atom_float atom_getfloat(const t_atom *a) { return 0; }

t_atom_long atom_getlong(const t_atom *a){}
t_symbol *atom_getsym(const t_atom *a){}
long atom_gettype(const t_atom *a){ return 0;}

t_max_err atom_setfloat(t_atom *a, double b){}
t_max_err atom_setlong(t_atom *a, t_atom_long b){}
t_max_err atom_setsym(t_atom *a, t_symbol *b){}

t_max_err class_addmethod(t_class *c, C74_CONST method m, C74_CONST char *name, ...){}
t_class *class_new(C74_CONST char *name, C74_CONST method mnew, C74_CONST method mfree, long size, C74_CONST method mmenu, short type, ...){}
t_max_err class_register(t_symbol *name_space, t_class *c){}

void error(C74_CONST char *fmt, ...){}
void poststring(const char *s){}

t_symbol *gensym(C74_CONST char *s){}

void *inlet_new(void *x, C74_CONST char *s){return 0;}
void *outlet_new(void *x, C74_CONST char *s){return 0;}

void *object_alloc(t_class *c){}
void object_warn(t_object *x, C74_CONST char *s, ...){}

void *outlet_bang(t_outlet *x){}
void *outlet_float(t_outlet *x, double v){}
void *outlet_int(t_outlet *x, long v){}
void *outlet_list(t_outlet *x, t_symbol *s, short ac, t_atom *av){}

void *proxy_new(void *x, long id, long *stuffloc){}
void proxy_delete(void *xx){}
