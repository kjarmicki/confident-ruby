# Use a guard clause to effect an early return from the method, in the special case.

def log_reading(reading_or_readings)
  return if @quiet # this is a guard clause AKA early return

  readings = Array(reading_or_readings)
  readings.each do |reading|
    puts "[READING %3.2f" % reading.to_f
  end
end