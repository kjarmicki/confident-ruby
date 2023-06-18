# Use Ruby's capitalized conversion functions, such as Integer and Array

require 'pathname'

def integer_conversions
  conv = [
    Integer(10),
    Integer(10.1), # 10, discards floating point
    Integer("0x10"), # 16
    Integer("010"), # 8
    Integer("0b10"), # 2
    Integer(Time.now),
  ]

  conv.each { |c| puts(c) }

  Integer("random stuff") # won't work
end

integer_conversions()

def file_size(filename)
  filename = Pathname(filename)
  filename.size
end

def file_size_examples()
  file_size(Pathname.new("/etc/hosts"))
  file_size("/etc/hosts")
end

file_size_examples()
