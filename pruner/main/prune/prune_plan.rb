require "./util/class_decorator"

class PrunePlan

  attr_accessor(
    :elements_retained,
    :elements_deleted
  )

  def initialize(elements_retained, elements_deleted)
    @elements_retained = elements_retained
    @elements_deleted = elements_deleted
  end

  def to_s
    result = ""
    result += "\n"
    result += "to retain:\n"
    backup_files_to_s(@elements_retained).each {|file| result += "  #{file}\n"}
    result += "to delete:\n"
    backup_files_to_s(@elements_deleted).each {|file| result += "  #{file}\n"}
    result
  end

  private def backup_files_to_s(files)
    files.map{|file| File.basename(file.absolute_path)}
  end

end
