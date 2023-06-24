# Replace the nil value with a special Null Object collaborator.
# The Null Object has the same interface as the usual collaborator, but it responds to messages by taking no action.

class FFMPEG
  def initialize(logger)
    @logger = logger
  end
  def record_screen(filename)
    # do stuff

    # special case - logger may not be present
    if @logger
      @logger.info("Executing ffmpeg")
    end
  end
end

class NullLogger
  def debug(*) end
  def info(*) end
  def warn(*) end
  def error(*) end
  def fatal(*) end
end

class FFMPEG2
  def initialize(logger=NullLogger.new)
    @logger = logger
  end

  def record_screen(filename)
    # do stuff

    # no special case anymore - logger is always present, even if it's a Null Logger
    @logger.info("Executing ffmpeg")
  end
end

# in Ruby, it's possible to define an all-purpose generic Null Object
class NullObject < BasicObject
  def method_missing(*)
  end

  def respond_to?(name)
    true
  end
end

# or a Black Hole Null Object, which always returns itself
class BlackHoleNullObject < BasicObject
  def method_missing(*)
    self
  end

  def respond_to?(name)
    true
  end
end

# black hole null objects are useful when there's a long call chain on a possibly nullable object
def send_request(http, request, metrics = BlackHoleNullObject.new)
  metrics.request.attempted += 1
  response = http.request(request)
  metrics.request.successful += 1
  metrics.response_codes[response.code] += 1
  response
end

# but they can also be "infectious", springing up in places where we don't expect them
def create_widget(attributes = {}, data_store = BlackHoleNullObject.new)
  data_store.store(Widget.new(attributes)) # returns BlackHoleNullObject!
end

def create_widget_and_get_manifest()
  widget = create_widget({a: 1, b: 2}) # whoops! widget is BlackHoleNullObject
  widget.manifest # and so is the manifest, wreaking havoc on the rest of the system
end

# remedy - explicitly returning an object or nil. seems sketchy, relies on programmer discipline
def Actual(object)
  case object
  when BlackHoleNullObject then nil
  else object
  end
end

# black hole not leaking anymore
def safely_create_widget(attributes = {}, data_store = BlackHoleNullObject.new)
  Actual(data_store.store(Widget.new(attributes))) # returns BlackHoleNullObject!
end
