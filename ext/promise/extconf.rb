require 'mkmf'

def add_define(name)
  $defs.push("-D#{name}")
end

dir_config('promise')

add_define 'RUBY19' if have_func('rb_thread_blocking_region') && have_macro('RUBY_UBF_IO', 'ruby.h')
add_define 'RUBY18' if have_var('rb_trap_immediate', ['ruby.h', 'rubysig.h'])

create_makefile('promise')