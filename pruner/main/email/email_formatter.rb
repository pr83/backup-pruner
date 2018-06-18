require 'mustache'
require "./prune/prune_plan"

class EmailFormatter

  def format(prune_plan, config)
    Mustache.render(
      File.read(File.join(File.dirname(__FILE__),"template.html")),
      {
        elements_retained: prune_plan.elements_retained.map(&method(:file_name)),
        elements_deleted: prune_plan.elements_deleted.map(&method(:file_name)),
        do_prune: config.do_prune,
        deleted: !prune_plan.elements_deleted.empty?
      }
    )
  end

  private def file_name(backup_file)
    File.basename(backup_file.absolute_path)
  end

end
