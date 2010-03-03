#include "ruby.h"

typedef struct {
    VALUE thread;
    VALUE computation;
    VALUE result;
} RPromise;

static ID s_value;

#define GetPromiseStruct(obj) (Check_Type(obj, T_DATA), (RPromise*)DATA_PTR(obj))
#define PromiseResult(pr) \
    RPromise* prs = GetPromiseStruct(pr); \
    if (!prs->result) prs->result = rb_funcall(prs->thread, s_value, 0); \
    return prs->result;

VALUE rb_cPromise;

static void mark_promise(RPromise* pr)
{
    rb_gc_mark(pr->computation);
    rb_gc_mark(pr->result);
}

static void free_promise(RPromise* pr)
{
    xfree(pr);
}

static VALUE
promise_alloc(VALUE klass)
{
    VALUE pr;
    RPromise* prs;
    pr = Data_Make_Struct(klass, RPromise, mark_promise, free_promise, prs);
    prs->thread = 0;
    prs->computation = Qnil;
    prs->result = 0;
    return pr;
}

static VALUE
rb_promise_new()
{
    return promise_alloc(rb_cPromise);
}

static VALUE
rb_promise_compute_deferred(void *pr){
    RPromise* prs = GetPromiseStruct(pr);
    VALUE args[0];
    return rb_proc_call(prs->computation, (VALUE)args);
}

static VALUE 
rb_promise_initialize(VALUE pr)
{
    RPromise* prs = GetPromiseStruct(pr);
    rb_need_block();
    prs->computation = rb_block_proc();
    prs->thread = rb_thread_create(rb_promise_compute_deferred, (void*)(VALUE)pr);
    return pr;
}

static VALUE 
rb_promise_result_argc_any(int argc, VALUE *argv, VALUE pr)
{
   PromiseResult(pr);
}

static VALUE 
rb_promise_result_argc_two(VALUE pr, VALUE arg1, VALUE arg2)
{
   PromiseResult(pr);
}

static VALUE 
rb_promise_result_argc_one(VALUE pr, VALUE arg)
{
   PromiseResult(pr);
}

static VALUE 
rb_promise_result_argc_none(VALUE pr)
{
   PromiseResult(pr);
}

void
Init_promise()
{
    rb_cPromise  = rb_define_class("Promise", rb_cObject);
    rb_define_alloc_func(rb_cPromise, promise_alloc);
    
    rb_define_method(rb_cPromise, "initialize", rb_promise_initialize, 0);

    s_value = rb_intern("value");

#include "promise.h"
}