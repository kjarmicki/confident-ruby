# Write a method to check for the error state and raise an exception

def filter_through_pipe(command, message)
  result = checked_popen(command, "w+", ->{message}) do |process|
    process.write(message)
    process.close_write
    process.read
  end
  unless $?.success?
    raise ArgumentError, "Command exited with status #{$?.exitstatus}"
  end
  result
end

# instead of checking $? variable directly, we can write a bouncer method and hide this detail

def check_child_exit_status()
  unless $?.success?
    raise ArgumentError, "Command exited with status #{$?.exitstatus}"
  end
end

def filter_through_pipe_with_bouncer(command, message)
  result = checked_popen(command, "+", ->{message}) do |process|
    process.write(message)
    process.close_write
    process.read
  end
  check_child_exit_status
  result
end

# or alternatively, wrap and yield

def check_child_exit_status_with_yield()
  result = yield
  unless $?.success?
    raise ArgumentError, "Command exited with status #{$?.exitstatus}"
  end
  result
end

def filter_through_pipe_with_wrap(command, message)
  check_child_exit_status_with_yield do
    checked_popen(command, "+", ->{message}) do |process|
      process.write(message)
      process.close_write
      process.read
    end
  end
end

# benefit: error checking is hidden from the main narrative, DRY of repetitive error handling code