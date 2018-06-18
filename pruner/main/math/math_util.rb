class MathUtil

  def self.log(x, base)
    Math.log(x) / Math.log(base)
  end

  def self.pow(x, y)
    Math.exp(y * Math.log(x))
  end

end
