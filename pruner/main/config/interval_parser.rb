require "active_support/core_ext/hash/indifferent_access"
require "./util/class_decorator"

class IntervalParser

  class SingleUnitInterval

    include ClassDecorator

    attr_accessor(
      :value,
      :unit
    )

    def initialize(value, unit)
      @value = value
      @unit = unit
    end

  end

  private_constant :SingleUnitInterval

  SECONDS_IN_MINUTE = 60
  SECONDS_IN_HOUR = SECONDS_IN_MINUTE * 60
  SECONDS_IN_DAY = SECONDS_IN_HOUR * 24
  SECONDS_IN_WEEK = SECONDS_IN_DAY * 7
  SECONDS_IN_MONTH = SECONDS_IN_DAY * 30
  SECONDS_IN_YEAR = SECONDS_IN_DAY * 365

  UNITS = {
    s: 1,
    m: SECONDS_IN_MINUTE,
    h: SECONDS_IN_HOUR,
    d: SECONDS_IN_DAY,
    w: SECONDS_IN_WEEK,
    M: SECONDS_IN_MONTH,
    y: SECONDS_IN_YEAR
  }.with_indifferent_access

  def initialize(interval_string)
    @interval_string = interval_string
    @position = 0
  end

  def parse
    result = 0

    swallow_whitespace

    while @position < @interval_string.length && digit?(@interval_string[@position])
      single_unit_interval = parse_single_unit_interval

      unit = UNITS[single_unit_interval.unit]
      if unit == nil
        raise_exception "Invalid unit '#{single_unit_interval.unit}'"
      end

      result += single_unit_interval.value * unit
    end

    if @position < @interval_string.length
      raise_exception "Invalid character"
    end

    result
  end

  private def parse_single_unit_interval
    value = parse_number
    swallow_whitespace
    unit = parse_unit
    swallow_whitespace
    SingleUnitInterval.new(value, unit)
  end

  private def parse_number
    value = 0
    while @position < @interval_string.length && digit?(@interval_string[@position])
      value = value * 10 + @interval_string[@position].to_i
      @position = @position + 1
    end
    value
  end

  private def parse_unit
    value = ""
    while @position < @interval_string.length && letter?(@interval_string[@position])
      value = value + @interval_string[@position]
      @position = @position + 1
    end
    value
  end

  private def swallow_whitespace
    while @position < @interval_string.length && whitespace?(@interval_string[@position])
      @position = @position + 1
    end
  end

  private def digit?(character)
    character =~ /[[:digit:]]/
  end

  private def letter?(character)
    character =~ /[A-Za-z]/
  end

  private def whitespace?(character)
    character =~ /[[:blank:]]/
  end

  private def raise_exception(description)
    raise description + " at position #{@position.to_s} in '#{@interval_string}'."
  end

end
