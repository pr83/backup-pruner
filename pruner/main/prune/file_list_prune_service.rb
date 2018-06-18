require "fileutils"

require "./file/list_files_service"
require "./optimalcount/optimal_count_ago"
require "./optimalcount/optimal_count_calculator"
require "./prune/list_prune_service"

class FileListPruneService

  def execute(files_list, config)
    optimal_count = OptimalCountCalculator.new(config)

    optimal_total_count =
      (
        optimal_count.optimal_count_ago(files_list.last.created_seconds_ago) -
        optimal_count.optimal_count_ago(files_list.first.created_seconds_ago)
      ).round

    list_prune_service = ListPruneService.new
    list_prune_service.prune(
      files_list,
      optimal_total_count,
      -> (element) {optimal_count.optimal_count_ago(element.created_seconds_ago)},
      true
    )
  end

end
