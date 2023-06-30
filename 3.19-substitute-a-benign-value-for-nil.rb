# Substitute a benign, known-good value for missing parameters

class Member
  def fname
    "john"
  end

  def lname
    "smith"
  end

  def address
    "wonderland"
  end
end

class Group
  def city_location
    Location.new("neverland")
  end
end

class Location
  def initialize(address)
    @address = address
  end
  def map_url
    "maps.google.com/#{@address}"
  end
end

class Geolocation
  def self.locate(address)
    # sometimes fails
    if rand() > 0.5
      return nil
    end
    Location.new(address)
  end
end

def render_member(member, group)
  location = Geolocation.locate(member.address) || group.city_location
  # ^ this is a benign value - a known-good object that stands in for a missing input
  html = ""
  html << "<div>"
  html << " <div>#{member.fname} #{member.lname}</div>"
  html << "<div>#{location.map_url}</div>"
end

def use_member()
  member = Member.new
  group = Group.new
  rendered = render_member(member, group)
  puts rendered
end

use_member()
