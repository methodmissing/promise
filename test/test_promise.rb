require "test/unit"
require "promise"

class TestPromise < Test::Unit::TestCase
  def test_initialize
    assert_instance_of Promise, Promise.new{ 1 * 1 }
  end

  def test_initialize_without_computation
    assert_raises(LocalJumpError) {
      Promise.new
    }
  end
  
  def test_computation
    promise = Promise.new{ 1 * 1 }
    assert_equal 1, promise.a_value
    assert_equal 1, promise.object_id
  end

  def test_blocking_computation
    promise = Promise.new{ 1000.times{ IO.read(__FILE__) } }
    assert_equal 1000, promise.class
  end
end