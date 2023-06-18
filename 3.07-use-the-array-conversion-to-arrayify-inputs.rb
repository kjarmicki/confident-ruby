# Use the Array() conversion function to coerce the input into an Array

def array_conversions
  conv = [
    Array("foo"),
    Array([1, 2, 3]),
    Array([]),
    Array(nil),
    Array({a: 1, b: 2}),
    Array(1..5)
  ]

  conv.each { |c| puts(c.to_s) }
end

array_conversions()

# use case: a logging function that accepts whatever crap is thrown at it, worst case scenario doesn't log anything
def log_reading(reading_or_readings)
  readings = Array(reading_or_readings)
  readings.each do |reading|
    puts "[READING] %3.2f" % reading.to_f
  end
end

log_reading(3.14)
log_reading([])
log_reading([87.9, 45.8674, 32])
log_reading(nil)