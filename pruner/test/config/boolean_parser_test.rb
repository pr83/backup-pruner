require "test/unit"
require './config/boolean_parser'

class BooleanParserTest < Test::Unit::TestCase

  def test_nil
    assert_false BooleanParser.new.parse(nil)
  end

  def test_empty
    assert_false BooleanParser.new.parse("")
  end

  def test_non_boolean
    assert_false BooleanParser.new.parse("xxx")
  end

  def test_false
    assert_false BooleanParser.new.parse("false")
  end

  def test_false_camelcase
    assert_false BooleanParser.new.parse("False")
  end

  def test_false_uppercase
    assert_false BooleanParser.new.parse("FALSE")
  end

  def test_true
    assert_true BooleanParser.new.parse("true")
  end

  def test_true_camelcase
    assert_true BooleanParser.new.parse("True")
  end

  def test_true_uppercase
    assert_true BooleanParser.new.parse("TRUE")
  end

end
