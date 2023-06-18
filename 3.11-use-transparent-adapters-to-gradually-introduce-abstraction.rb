# Make adapter objects transparent delegators to the object they adapt, easing the transition to a more decoupled design.

require 'delegate'

class CinchBot
  def dispatch(action, message)
    if action == :log_info
      puts "[LOG_CHANNEL] #{message}"
    end
  end
end

class BenchmarkedLogger
  class CinchBotSink < DelegateClass(CinchBot)
    def <<(message)
      dispatch(:log_info, message)
    end
  end

  def initialize(sink)
    @sink = case sink
            when CinchBot then IrcBotSink.new(sink)
            else sink
            end
  end

  def info(message)
    start_time = Time.now
    yield
    duration = start_time - Time.now
    @sink << ("[%1.3f] %s\n" % [duration, message])
  end
end
