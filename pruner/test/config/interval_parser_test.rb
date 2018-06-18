require "test/unit"
require './config/interval_parser'

class IntervalParserTest < Test::Unit::TestCase

  def test_1_s
    assert_equal(1, IntervalParser.new("1s").parse)
  end

  def test_n_s
    n = 123
    assert_equal(n, IntervalParser.new("#{n.to_s}s").parse)
  end

  def test_1_m
    assert_equal(60, IntervalParser.new("1m").parse)
  end

  def test_n_m
    n = 456
    assert_equal(60 * n, IntervalParser.new("#{n.to_s}m").parse)
  end

  def test_1_h
    assert_equal(60 * 60, IntervalParser.new("1h").parse)
  end

  def test_n_h
    n = 789
    assert_equal(60 * 60 * n, IntervalParser.new("#{n.to_s}h").parse)
  end

  def test_1_d
    assert_equal(24 * 60 * 60, IntervalParser.new("1d").parse)
  end

  def test_n_d
    n = 234
    assert_equal(24 * 60 * 60 * n, IntervalParser.new("#{n.to_s}d").parse)
  end

  def test_1_w
    assert_equal(7 * 24 * 60 * 60, IntervalParser.new("1w").parse)
  end

  def test_n_w
    n = 567
    assert_equal(7 * 24 * 60 * 60 * n, IntervalParser.new("#{n.to_s}w").parse)
  end

  def test_1_month
    assert_equal(30 * 24 * 60 * 60, IntervalParser.new("1M").parse)
  end

  def test_n_month
    n = 890
    assert_equal(30 * 24 * 60 * 60 * n, IntervalParser.new("#{n.to_s}M").parse)
  end

  def test_1_y
    assert_equal(365 * 24 * 60 * 60, IntervalParser.new("1y").parse)
  end

  def test_n_y
    n = 890
    assert_equal(365 * 24 * 60 * 60 * n, IntervalParser.new("#{n.to_s}y").parse)
  end

  def test_n_d_m_h
    n = 345
    m = 678
    assert_equal(24 * 60 * 60 * n + 60 * 60 * m, IntervalParser.new("#{n.to_s}d#{m.to_s}h").parse)
  end

  def test_n_d_m_h_with_space
    n = 345
    m = 678
    assert_equal(24 * 60 * 60 * n + 60 * 60 * m, IntervalParser.new(" #{n.to_s} d #{m.to_s} h").parse)
  end

  def test_invalid_character_beginning
    assert_raise_message("Invalid character at position 0 in '*5d'.") do
      IntervalParser.new("*5d").parse
    end
  end

  def test_invalid_character_after_unit
    assert_raise_message("Invalid character at position 2 in '5d*'.") do
      IntervalParser.new("5d*").parse
    end
  end

  def test_invalid_character_after_unit_before_next_definition
    assert_raise_message("Invalid character at position 2 in '5d*10h'.") do
      IntervalParser.new("5d*10h").parse
    end
  end

  def test_invalid_unit
    assert_raise_message("Invalid unit 'x' at position 2 in '5x'.") do
      IntervalParser.new("5x").parse
    end
  end

end
