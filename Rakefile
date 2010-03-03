require 'rake'
require 'rake/testtask'
require 'rake/clean'

PROMISE_ROOT = 'ext/promise'

PROMISE_ARGC_MAP = { -1 => "rb_promise_result_argc_any",
                      0 => "rb_promise_result_argc_none",
                      1 => "rb_promise_result_argc_one",
                      2 => "rb_promise_result_argc_two",}

PROMISE_METHODS_18 = %w[method_missing inspect tap clone public_methods object_id __send__ instance_variable_defined? equal? freeze extend send methods hash dup to_enum instance_variables eql? instance_eval id singleton_methods taint frozen? instance_variable_get enum_for instance_of? to_a method type instance_exec protected_methods method_missing == === instance_variable_set kind_of? respond_to? to_s class __id__ tainted? =~ private_methods untaint nil? is_a?]

PROMISE_ARGC_18 = { "==" => 1,
                    "equal?" => 1,
                    "===" => 1,
                    "=~" => 1,
                    "eql?" => 1,
                    "initialize_copy" => 1,
                    "method" => 1,
                    "instance_exec" => 1,
                    "instance_of?" => 1,
                    "kind_of?" => 1,
                    "is_a?" => 1,
                    "instance_variable_get" => 1,                    
                    "instance_variable_defined?" => 1,
                    "instance_variable_set" => 2,
                    "methods" => -1,
                    "singleton_methods" => -1,
                    "protected_methods" => -1,
                    "private_methods" => -1,
                    "public_methods" => -1,
                    "__send__" => -1,
                    "send" => -1,
                    "to_enum" => -1,
                    "instance_eval" => -1,
                    "enum_for" => -1,
                    "method_missing" => -1,
                    "respond_to?" => -1
                  }

desc 'Default: test'
task :default => :test

desc 'Run promise tests.'
Rake::TestTask.new(:test) do |t|
  t.libs = [PROMISE_ROOT]
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end
task :test => :build

namespace :build do
  file "#{PROMISE_ROOT}/promise.c"
  file "#{PROMISE_ROOT}/extconf.rb"
  file "#{PROMISE_ROOT}/Makefile" => %W(#{PROMISE_ROOT}/promise.c #{PROMISE_ROOT}/extconf.rb) do
    Dir.chdir(PROMISE_ROOT) do
      ruby 'extconf.rb'
    end
  end

  desc "generate makefile"
  task :makefile => %W(#{PROMISE_ROOT}/Makefile #{PROMISE_ROOT}/promise.c)

  dlext = Config::CONFIG['DLEXT']
  file "#{PROMISE_ROOT}/promise.#{dlext}" => %W(#{PROMISE_ROOT}/Makefile #{PROMISE_ROOT}/promise.c) do
    Dir.chdir(PROMISE_ROOT) do
      sh 'make' # TODO - is there a config for which make somewhere?
    end
  end

  desc "compile promise extension"
  task :compile => "#{PROMISE_ROOT}/promise.#{dlext}"

  task :clean do
    Dir.chdir(PROMISE_ROOT) do
      sh 'make clean'
    end if File.exists?("#{PROMISE_ROOT}/Makefile")
  end

  File.open("#{PROMISE_ROOT}/promise.h", "w+"){|h|
    def_method = lambda do |m|
      argc = PROMISE_ARGC_18[m] || 0
      h.write "rb_define_method(rb_cPromise, \"#{m}\", #{PROMISE_ARGC_MAP[argc]}, #{argc.to_s});\n" 
    end  
    h.write "#ifdef RUBY18\n"
    PROMISE_METHODS_18.each{|m| def_method.call(m) }
    h.write "#endif\n"
  }

  CLEAN.include("#{PROMISE_ROOT}/Makefile")
  CLEAN.include("#{PROMISE_ROOT}/promise.#{dlext}")
end

task :clean => %w(build:clean)

desc "compile"
task :build => %w(build:compile)

task :install do |t|
  Dir.chdir(PROMISE_ROOT) do
    sh 'sudo make install'
  end
end

desc "clean build install"
task :setup => %w(clean build install)

desc "run benchmarks"
task :bench do
  ruby "bench/promise.rb"
end
task :bench => :build

desc "build gem"
task :gem do
  sh "gem build promise.gemspec"
end