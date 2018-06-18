require 'test/unit'
require './optimalcount/optimal_count_ago'

class OptimalCountAgoTest < Test::Unit::TestCase

  def test_class
    time_ago = 10
    count = 6
    optimal_count_ago = OptimalCountAgo.new(time_ago, count)

    assert_equal(time_ago, optimal_count_ago.time_ago)
    assert_equal(count, optimal_count_ago.count)
  end

end
