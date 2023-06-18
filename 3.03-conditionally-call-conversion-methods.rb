# Make the call to a conversion method conditional on whether the object can respond to that method

def string_respond_to
  path = "#{ENV['HOME']}/.zshrc"
  puts(path.respond_to?(:to_path)) # false
  puts(File.open(path)) # still works, see below why
end

string_respond_to()

class PathResponder
  def to_path
    "#{ENV['HOME']}/.zshrc"
  end
end

# This method is similar to what File.open does under the hood.
# This is the general philosophy of handling inputs in Ruby:
# Allow any type and call conventional methods to convert it to the desired type.
def convert_to_path(filename)
  if filename.respond_to?(:to_path)
    filename = filename.to_path
  end
  unless filename.is_a?(String)
    filename = filename.to_str
  end
  filename
end

# This method we'll use as an example, validation needs to happen before
def my_open(filename)
  filename.strip!
  filename.gsub!(/^~/, ENV['HOME'])
  File.open(filename)
end

# This is an antipattern in Ruby: method should validate input based on contracts, not strict types.
def strict_validate_path(filename)
  raise TypeError unless filename.is_a?(String)
end

# This is also an antipattern - it has to know about internal details of my_open
def rigid_validate_path(filename)
  unless %w[strip! gsub!].all{|m| filename.respond_to?(m)}
    raise TypeError, "Protocol not supported"
  end
end

def string_validate_path(filename)
  filename.to_str # wouldn't work for pathname objects, they do not define to_str
  filename.to_s # would work for invalid inputs, like nil
end

# it's possible (and discouraged) to augment any class with any method
class String
  def to_path
    self
  end
end

def path_responder_vs_string
  p = PathResponder.new
  puts(File.open(convert_to_path(p)))
end

path_responder_vs_string()