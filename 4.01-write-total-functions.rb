# Return a possibly zero-length collection of results in all cases

# returns array for multiple results, single item for single result and nil for zero results
# painful to work with
def find_words(prefix)
  words = File.readlines('/usr/share/dict/words').
    map(&:chop).reject{|w| w.include?("'")}
  matches = words.select{|w| w =~ /\A#{prefix}/}
  case matches.size
  when 0 then nil
  when 1 then matches.first
  else matches
  end
end

# solution: delete the case statement
def find_words_total(prefix)
  words = File.readlines('/usr/share/dict/words').
    map(&:chop).reject{|w| w.include?("'")}
  words.select{|w| w =~ /\A#{prefix}/}
end
