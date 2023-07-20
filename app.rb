# frozen_string_literal: true

class Car
  def initialize(name)
    @name = name
  end

  def honk(n, sound: :beep)
    n.times.map { sound }
  end

  def drive
    :drive
  end
end
