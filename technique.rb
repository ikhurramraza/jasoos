# frozen_string_literal: true

def time_it(&block)
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  return_value = block.call
  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  puts "It took #{(end_time - start_time)} ms"

  return return_value
end

def expensive_method
  sleep 2

  return :expensive_calculation
end

puts expensive_method
