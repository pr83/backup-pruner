require "test/unit"
require './prune/prune_plan'
require './file/backup_file'
require './email/email_formatter'
require './config/config'

class EmailFormatterTest < Test::Unit::TestCase

  def test_mustache
    elements_retained = [
        BackupFile.new("path/to_retain_1", 0),
        BackupFile.new("path/to_retain_2", 0)
    ]

    elements_deleted = [
        BackupFile.new("path/to_delete1", 0),
        BackupFile.new("path/to_delete2", 0)
    ]

    config = Config.new
    puts EmailFormatter.new.format(PrunePlan.new(elements_retained, elements_deleted), config)
  end

end
