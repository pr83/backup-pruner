require 'test/unit'
require './optimalcount/optimal_count_ago'
require './optimalcount/optimal_count_calculator'

class OptimalCountCalculatorTest < Test::Unit::TestCase

  def test_empty
    # given
    optimal_count = OptimalCountCalculator.new([])
    some_time_ago = 10.0
    expected = 0.0

    # when
    actual = optimal_count.optimal_count_ago(some_time_ago)

    # then
    assert_equal(expected, actual)
  end

  def test_single_point_defined
    # given
    count = 1.0
    time_ago = count * count
    expected = 3.0
    queried_time_ago = expected * expected
    optimal_count =
      OptimalCountCalculator.new(
        [
          OptimalCountAgo.new(time_ago, count)
        ]
      )

    # when
    actual = optimal_count.optimal_count_ago(queried_time_ago)

    # then
    assert_equal(expected, actual)
  end

  def test_first_interval
    # given
    count = 3.0
    time_ago = count * count
    expected = 1.0
    queried_time_ago = expected * expected
    optimal_count =
        OptimalCountCalculator.new(
            [
                OptimalCountAgo.new(time_ago, count),
                OptimalCountAgo.new(9999, 99),
            ]
        )

    # when
    actual = optimal_count.optimal_count_ago(queried_time_ago)

    # then
    assert_equal(expected, actual)
  end

  def test_middle_interval
    # given
    point_before_count = 1.0
    point_before_time_ago = point_before_count * point_before_count
    expected = 2.0
    queried_time_ago = expected * expected
    point_after_count = 3.0
    point_after_time_ago = point_after_count * point_after_count
    optimal_count =
      OptimalCountCalculator.new([
        OptimalCountAgo.new(point_before_time_ago, point_before_count),
        OptimalCountAgo.new(point_after_time_ago, point_after_count),
        OptimalCountAgo.new(9999, 99),
      ])

    # when
    actual = optimal_count.optimal_count_ago(queried_time_ago)

    # then
    assert_in_delta(expected, actual)
  end

  def test_last_interval
    # given
    first_count = 1.0
    first_time_ago = first_count * first_count
    second_count = 2.0
    second_time_ago = second_count * second_count
    expected = 3.0
    queried_time_ago = expected * expected
    optimal_count = OptimalCountCalculator.new([
      OptimalCountAgo.new(first_time_ago, first_count),
      OptimalCountAgo.new(second_time_ago, second_count),
    ])

    # when
    actual = optimal_count.optimal_count_ago(queried_time_ago)

    # then
    assert_in_delta(expected, actual)
  end

  def test_all
    optimal_count = OptimalCountCalculator.new([
       OptimalCountAgo.new(1.0, 1.0),
       OptimalCountAgo.new(3.0, 2.0),
       OptimalCountAgo.new(10.0, 5.0),
       OptimalCountAgo.new(30.0 , 10.0),
       OptimalCountAgo.new(90.0, 12.0),
       OptimalCountAgo.new(365.0, 15.0)
   ])

    (0..500).each do |days_ago|
      puts days_ago.to_s + "\t" + optimal_count.optimal_count_ago(days_ago).to_s
    end

  end

end
