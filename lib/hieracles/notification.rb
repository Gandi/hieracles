module Hieracles
  class Notification
    attr_reader :level, :message, :timestamp, :source

    LEVEL = {
      'fatal' => 0,
      'error' => 1,
      'warning' => 2,
      'info' => 3,
      'debug' => 4
    }

    def initialize(source, message, level = 'info')
      @source = source
      @level = level
      @message = message
      @timestamp = Time.new
    end

    def to_hash
      {
        'source' => @source,
        'level' => @level,
        'message' => @message,
        'timestamp' => @timestamp
      }
    end

  end
end
    
