require "./util/class_decorator"

class OptimalCountAgo

  include ClassDecorator

  attr_reader(
    :time_ago,
    :count
  )

  def initialize(time_ago, count)
    @time_ago = time_ago
    @count = count
  end

  def ==(another)
    another != nil && another.time_ago == @time_ago && another.count == @count
  end

end
