# Use Ruby's defined conversion protocols, like .to_str
# You need it since Ruby is too cute to deal with types explicitly.

Place = Struct.new(:index, :name, :prize) do
  # makes Place instance usable as an index
  # Ruby internally calls .to_int when a program uses array access through index
  def to_int
    index
  end
end

def announcing_winners
  # an array of race winners, ordered by the place thet finished in
  winners = [
    "Homestar",
    "King of Town",
    "Marzipan",
    "Strongbad"
  ]

  first = Place.new(0, "first", "Peasant's Quest game")
  second = Place.new(1, "second", "Limozeen Album")
  third = Place.new(2, "third", "Butter-da")

  puts(winners[first]) # calls .to_int
end

announcing_winners()

class ZshConfigFile
  def initialize
    @filename = "#{ENV['HOME']}/.zshrc"
  end

  # to_path will be called when instance of this class is used as a path
  def to_path
    @filename
  end
end

def config_file()
  zsh_config = ZshConfigFile.new
  puts(File.open(zsh_config).each_line.count)
end

config_file()


# explicit and implicit conversions:
# to_s is explicit - it's explicitly called by other objects to stringify a given object
# to_str is implicit - it's implicitly called by the Ruby core objects when operation requires a string
# almost every core class in Ruby implements explicit conversions, but none implement implicit by default

class ArticleTitle
  def initialize(text)
    @text = text
  end

  def slug
    @text.strip.tr_s("^A-Za-z0-9", "-").downcase
  end

  def to_str
    @text
  end

  def to_s
    to_str
  end
end

def implicit_conversion()
  title = ArticleTitle.new("A Modest Proposal")
  puts("Today's feature: " + title)
end

implicit_conversion()