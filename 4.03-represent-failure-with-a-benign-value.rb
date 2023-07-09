# Return a default value, such as an empty string, which will not interfere with the normal operation of the caller

# writing a function that fetches text content of the latest tweets and can possibly fail

def latest_tweets_nil()
  begin
    # fetch tweets somehow
  rescue Net::HTTPError
    nil # arguably the worst way of handling error - carries no meaning, forces client to handle it
  end
end

def latest_tweets_empty()
  begin
    # fetch tweets somehow
  rescue Net::HTTPError
    "" # when return value is non-essential it's acceptable to return an empty value and let the caller handle it
  end
end

# personal note - I disagree with the premise
# the importance of the call should be determined by the function calling, not the function being called
# so called function shouldn't return empty values silently because its result it "non-essential"
