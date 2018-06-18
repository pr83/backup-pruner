require "./optimalcount/optimal_count_ago"
require "./config/interval_parser"

class OptimalCountConfig

  attr_reader :config

  def initialize(config_string)
    @config = config_string.split(/,\s*/).map(&method(:parse_point))
  end

  private def parse_point(point_string)
    parts = point_string.split(/\s*:\s*/)
    OptimalCountAgo.new(IntervalParser.new(parts[0]).parse, parts[1].to_i)
  end

end
