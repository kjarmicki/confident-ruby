# Wrap input objects with adapters to give them a consistent interface.

class BenchmarkedLogger
  class IrcBotSink
    def initialize(bot)
      @bot = bot
    end

    def <<(message)
      @bot.dispatch(:log_info, message)
    end
  end

  def initialize(sink = $stdout)
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

class CinchBot
  def dispatch(action, message)
    if action == :log_info
      puts "[LOG_CHANNEL] #{message}"
    end
  end
end

def logger_with_adapters
  bot = CinchBot.new
  bot_logger = BenchmarkedLogger.new(bot)
  bot_logger.info('bot logger test') do
    sleep 1
  end
  array_logger = BenchmarkedLogger.new([])
  array_logger.info('array logger test') do
    sleep 1
  end
end

logger_with_adapters()