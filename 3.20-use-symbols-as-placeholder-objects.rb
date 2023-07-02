# Use a meaningful symbol, rather than nil, as a placeholder value.

def list_widgets(options = {})
  credentials = options[:credentials]
  page_size = options.fetch(:page_size) { 20 }
  page = options.fetch(:page) { 20 }

  if page_size > 20
    user = credentials.fetch(:user)
    password = credentials.fetch(:password)
    url = "https://#{user}:#{password}@" +
      "www.example/com/widgets?page=#{page}&page_size=#{page_size}"
  else
    url = "https://www.example.com/widgets?page=#{page}&page_size#{page_size}"
  end

  puts "Contacting #{url}"
end

list_widgets() # default

begin
  list_widgets(page_size: 50) # boom! nil
rescue
  puts "nil!"
end

def how_to_get_a_nil()
  h = {
    'ithere' => nil
  }
  puts h['alfbaked'] # nil
  puts h['ithere'] # also nil

  result = if (2 + 2) == 5
             "unlikely."
           end
  # no else, so result is nil
  puts result

  type = case :foo
         when String then "string"
         when Integer then "integer"
         end
  # no else, so result is nil
  puts type

  puts @undefined_instance_variable # nil

  # and so on, and so on
end

how_to_get_a_nil()

def list_widgets_with_symbol(options = {})
  credentials = options.fetch(:credentials) { :credentials_not_set }
  page_size = options.fetch(:page_size) { 20 }
  page = options.fetch(:page) { 20 }

  if page_size > 20
    user = credentials.fetch(:user)
    password = credentials.fetch(:password)
    url = "https://#{user}:#{password}@" +
      "www.example/com/widgets?page=#{page}&page_size=#{page_size}"
  else
    url = "https://www.example.com/widgets?page=#{page}&page_size#{page_size}"
  end

  puts "Contacting #{url}"
end

list_widgets_with_symbol(page_size: 50) # boom! but this time, at least we have a trace of what's happening
# `list_widgets_with_symbol': undefined method `fetch' for :credentials_not_set:Symbol (NoMethodError)
