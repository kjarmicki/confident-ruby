# Provide default values for optional hash keys using hash.fetch

class Logger
  def initialize(output)
    @output = output
  end

  def info(message)
    @output << message
  end
end

# when logger is not passed, use default
# when it is passed as false, use dead-end array as output (yes, memory leak, doesn't matter)
def accept_optional_logger(options = {})
  logger = options.fetch(:logger) { Logger.new($stdout) }
  if logger == false
    logger = Logger.new([])
  end
  logger.info("hello")
end

accept_optional_logger()

accept_optional_logger(logger: false)