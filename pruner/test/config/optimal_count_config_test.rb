require 'test/unit'
require './config/optimal_count_config'

class OptimalCountConfigTest < Test::Unit::TestCase

  def test_parse
    optimal_count_config = OptimalCountConfig.new("1d: 1, 7d: 5, 30d: 8, 90d: 12, 365d: 15")
    puts optimal_count_config.config
  end

end
