require 'test/unit'
require './math/math_util.rb'

class TC_Prune < Test::Unit::TestCase

  def test_log
    assert_in_delta(2, MathUtil.log(100, 10))
    assert_in_delta(3, MathUtil.log(8, 2))
  end

  def test_pow()
    assert_in_delta(100, MathUtil.pow(10, 2), 0.01)
    assert_in_delta(8, MathUtil.pow(2, 3), 0.01)
  end

end
