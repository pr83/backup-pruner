require 'test/unit'
require './prune/list_prune_service'

class TC_Prune < Test::Unit::TestCase

  def test_nothing_to_prune

    # given
    list = [1, 2]
    expected = [1, 2]

    # when
    actual = ListPruneService.new.prune(list, 0, -> (element) {0}).elements_retained

    # then
    assert_equal(expected, actual)

  end

  def test_do_not_prune

    # given
    list = [1, 2, 3, 4]
    expected = [1, 2, 3, 4]

    # when
    actual = ListPruneService.new.prune(list, 2, -> (element) {0}).elements_retained

    # then
    assert_equal(expected, actual)

  end

  def test_prune_all

    # given
    list = [1, 2, 3, 4]
    expected = [1, 4]

    # when
    actual = ListPruneService.new.prune(list, 0, -> (element) {0}).elements_retained

    # then
    assert_equal(expected, actual)

  end

  def test_prune_in_smallest_gap_last_long_ago

    # given
    list = [1, 2, 3, 1000]
    expected = [1, 3, 1000]

    # when
    actual = ListPruneService.new.prune(list, 1, -> (element) {element}).elements_retained

    # then
    assert_equal(expected, actual)

  end

  def test_prune_in_smallest_gap_first_long_ago

    # given
    list = [1, 1000, 1001, 1002]
    expected = [1, 1000, 1002]

    # when
    actual = ListPruneService.new.prune(list, 1, -> (element) {element}).elements_retained

    # then
    assert_equal(expected, actual)

  end

  def test_prune_in_smallest_gaps_last_long_time_ago

    # given
    list = [1, 2, 3, 4, 5, 1000]
    expected = [1, 5, 1000]

    # when
    actual = ListPruneService.new.prune(list, 1, -> (element) {element}).elements_retained

    # then
    assert_equal(expected, actual)

  end

  def test_prune_in_smallest_gaps_first_long_ago

    # given
    list = [1, 1000, 1001, 1002, 1003, 1004]
    expected = [1, 1000, 1004]

    # when
    actual = ListPruneService.new.prune(list, 1, -> (element) {element}).elements_retained

    # then
    assert_equal(expected, actual)

  end

  def test_calc
    puts Math.exp(0.1 * Math.log(53))
    puts Math.exp(5 * Math.log(1.487))

    puts Math.log(1.487) * Math.log(7.27 * 7)
    puts Math.log(1.487) * Math.log(7.27 * 365)
  end

end
