# frozen_string_literal: true

def time_it(&block)
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  return_value = block.call
  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  puts "It took #{(end_time - start_time)}s"

  return return_value
end

class Foo
  def expensive_method
    sleep 2

    return :expensive_calculation
  end

  alias_method :old_expensive_method, :expensive_method

  def expensive_calculation
    time_it { old_expensive_method }
  end
end

puts Foo.new.expensive_calculation
