require "./prune/prune_plan"

class ListPruneService

  def prune(list, middle_elements_to_keep_count, value_function, sort=false)
    elements_retained = list.dup
    elements_deleted = []

    while elements_retained.length > middle_elements_to_keep_count + 2 do
      elements_deleted.push remove_least_valuable_element(elements_retained, value_function)
    end

    if sort
      elements_retained.sort_by!{|element| element.created_seconds_ago}
      elements_deleted.sort_by!{|element| element.created_seconds_ago}
    end

    PrunePlan.new elements_retained, elements_deleted
  end

  private def remove_least_valuable_element(result, value_function)
    first_middle_index = 1
    last_middle_index = result.length - 2

    lowest_value = nil
    index_with_lowest_value = nil

    (first_middle_index..last_middle_index).each do |current_index|

      current_element_value =
        value_function.call(result[current_index + 1]) - value_function.call(result[current_index - 1])

      if lowest_value == nil || current_element_value < lowest_value
        lowest_value = current_element_value
        index_with_lowest_value = current_index
      end

    end

    result.delete_at(index_with_lowest_value)
  end

end
