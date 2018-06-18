require "logger"

module ClassWithLogger

  def logger
    if @logger.nil?
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::DEBUG
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S "
    end
    @logger
  end

end
