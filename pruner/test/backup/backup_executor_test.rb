require 'test/unit'
require './prune/file_list_prune_service'
require './optimalcount/optimal_count_ago'

class TC_BackupExecutor < Test::Unit::TestCase

  def test_executor

    file_list = [
        BackupFile.new("/dir/file0", 0),
        BackupFile.new("/dir/file1", 1),
        BackupFile.new("/dir/file7", 5),
        BackupFile.new("/dir/file30", 8),
    ]

    file_list_prune_service = FileListPruneService.new
    result =
        file_list_prune_service.execute(
          file_list,
          [
              OptimalCountAgo.new(1, 1),
              OptimalCountAgo.new(7, 5),
              OptimalCountAgo.new(30, 8),
          ]
      )

    puts result
  end

end
