# Wrap the system or library call in a method that handles the possible exception

def filter_through_pipe(command, message)
  results = nil
  IO.popen(command, "w+") do |process|
    results = begin
                process.write(message)
                process.close_write
                process.read
              rescue Errno::EPIPE
              message
              end
    results
  end
end

# instead of having begin/rescue/end nested in the callback, we can convert it to top level and use a policy to handle error
def checked_popen(command, mode, error_policy=->{raise})
  IO.popen(command, mode) do |process|
    return yield(process)
  end
rescue Errno::EPIPE
  error_policy.call
end

# now filter tells clearer story
def filter_through_piple_checked(command, message)
  checked_popen(command, "w+", ->{message}) do |process|
    process.write(message)
    process.close_write
    process.read
  end
end
