# Switch to using ruby's top-level rescue clause syntax

def verbose
  begin
    # do some work
  rescue
    # handle failure
  end
  # do some more work
end

def short
  # do some work
rescue
  # failure scenario handling
end

# supposedly, the short form is better - it organizes code in a manner where important stuff happens first and the failure handling is pushed to the bottom