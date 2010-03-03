require "benchmark"
require "ext/promise/promise"

class RubyPromise
  def initialize(&blk)
    @thread = Thread.new(&blk)
    @result = nil
  end
  
  def method_missing(meth, *args)
    @result ||= @thread.value
  end
end

TESTS = 1000
Benchmark.bmbm do |results|
  results.report("Promise") { TESTS.times { Promise.new{ 1 }.undefined } }
  results.report("RubyPromise") { TESTS.times { RubyPromise.new{ 1 }.undefined } }    
  results.report("Promise#==") { TESTS.times { Promise.new{ 1 } == 1 } }
  results.report("RubyPromise#==") { TESTS.times { RubyPromise.new{ 1 } == 1 } }
  results.report("Promise#object_id") { TESTS.times { Promise.new{ 1 }.object_id } }
  results.report("RubyPromise#object_id") { TESTS.times { RubyPromise.new{ 1 }.object_id } }
  results.report("Promise#__send__") { TESTS.times { Promise.new{ 1 }.__send__ :object_id } }
  results.report("RubyPromise#__send__") { TESTS.times { RubyPromise.new{ 1 }.__send__ :object_id } }    
  results.report("Promise (blocking)") { TESTS.times { Promise.new{ IO.read(__FILE__) }.undefined } }
  results.report("RubyPromise (blocking)") { TESTS.times { RubyPromise.new{ IO.read(__FILE__) }.undefined } }    
  results.report("Promise#== (blocking)") { TESTS.times { Promise.new{ IO.read(__FILE__) } == 1 } }
  results.report("RubyPromise#== (blocking)") { TESTS.times { RubyPromise.new{ IO.read(__FILE__) } == 1 } }
  results.report("Promise#object_id (blocking)") { TESTS.times { Promise.new{ IO.read(__FILE__) }.object_id } }
  results.report("RubyPromise#object_id (blocking)") { TESTS.times { RubyPromise.new{ IO.read(__FILE__) }.object_id } }
  results.report("Promise#__send__ (blocking)") { TESTS.times { Promise.new{ IO.read(__FILE__) }.__send__ :object_id } }
  results.report("RubyPromise#__send__ (blocking)") { TESTS.times { RubyPromise.new{ IO.read(__FILE__) }.__send__ :object_id } }    
end