module ClassDecorator

  def to_s
    result = ""
    instance_variables.each do |instance_variable|
      result =
        result + instance_variable.to_s + ":" + instance_variable_get(instance_variable).to_s + "; "
    end
    result
  end

end
