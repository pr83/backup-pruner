class BooleanParser

  def parse(as_string)
    as_string != nil && as_string.downcase == "true"
  end

end
