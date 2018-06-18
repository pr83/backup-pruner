require "./file/backup_file"

class ListFilesService

  def list_files(directory, applicable_time)
    result = []

    Dir.entries(directory).each do |fileName|
      absolute_path = File.absolute_path(fileName, directory)
      if File.file?(absolute_path)
        result.push(
          BackupFile.new(
              absolute_path,
              applicable_time.to_i - File.mtime(absolute_path).to_i
          )
        )
      end
    end

    result.sort_by {|element| element.created_seconds_ago}
  end

end
