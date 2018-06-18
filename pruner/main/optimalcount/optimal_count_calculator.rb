require "./math/math_util"

class OptimalCountCalculator

  def initialize(definition)
    @definition = definition
  end

  def optimal_count_ago(time_ago)
    if @definition.empty?
      optimal_count_ago_empty_definition
    elsif @definition.length == 1 || time_ago <= @definition[0].time_ago
      optimal_count_ago_square_root(time_ago)
    else
      optimal_count_ago_generic_power(time_ago)
    end
  end

  private def optimal_count_ago_empty_definition
    0
  end

  private def optimal_count_ago_square_root(time_ago)
    coefficient = @definition[0].count / Math.sqrt(@definition[0].time_ago)
    coefficient * Math.sqrt(time_ago)
  end

  private def optimal_count_ago_generic_power(time_ago)

    (1..@definition.length - 1).each do |interval_right_index|
      if time_ago <= @definition[interval_right_index].time_ago
        interval_left_index = interval_right_index - 1
        return optimal_count_ago_generic_power_given_two_points(interval_left_index, interval_right_index, time_ago)
      end
    end

    optimal_count_ago_generic_power_given_two_points(@definition.length - 2, @definition.length - 1, time_ago)
  end

  private def optimal_count_ago_generic_power_given_two_points(point_1_index, point_2_index, time_ago)
    definition1 = @definition[point_1_index]
    definition2 = @definition[point_2_index]

    t1 = definition1.time_ago.to_f
    t2 = definition2.time_ago.to_f
    v1 = definition1.count.to_f
    v2 = definition2.count.to_f

    power = MathUtil.log(v1 / v2, t1 / t2)
    coefficient = v1 / MathUtil.pow(t1, power)

    coefficient * MathUtil.pow(time_ago, power)
  end

end
