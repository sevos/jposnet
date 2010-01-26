module LoggerHelper
  def log
    @object_log
  end

  def clear_log
    @object_log = []
  end

  private
    def log_message(message)
      (@object_log ||= []).push LogEntry.new(message)
    end
end

class LogEntry
  attr_reader :message, :time

  def initialize(message)
    @message, @time = message, Time.now
  end

  def to_s
    "#{@time}: #{@message}"
  end
end

class Class
  def logger
    include LoggerHelper
  end
end