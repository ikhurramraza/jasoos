# frozen_string_literal: true

require "debug"
require "minitest/autorun"

require_relative "app"
require_relative "spy_helper"

class CarTest < Minitest::Test
  def setup
    @car = Car.new("Honda")
  end

  def test_simple
    skip

    @car1 = Car.new("Suzuki")
    @car2 = Car.new("Toyota")

    calls =
      SpyHelper.spy_on(@car1, method: :honk) do
        @car1.honk(5)
        @car2.honk(3)
      end

    assert_equal 1, calls.length
    call = calls.first

    assert_equal(@car1, call.object)
    assert_equal(:honk, call.method_name)
    assert_equal([5], call.args)
    assert_equal({}, call.kwargs)
    assert_equal(%i[beep beep beep beep beep], call.return_value)
  end

  def test_kwargs
    skip

    calls = SpyHelper.spy_on(@car, method: :honk) { @car.honk(2, sound: :boop) }

    assert_equal 1, calls.length
    call = calls.first

    assert_equal(@car, call.object)
    assert_equal(:honk, call.method_name)
    assert_equal([2], call.args)
    assert_equal({ sound: :boop }, call.kwargs)
    assert_equal %i[boop boop], call.return_value
  end

  def test_multiple_calls
    skip

    calls =
      SpyHelper.spy_on(@car, method: :honk) do
        @car.honk(3)
        @car.honk(4)
      end

    assert_equal 2, calls.length
    first_call = calls.first
    second_call = calls.last

    assert_equal(@car, first_call.object)
    assert_equal(:honk, first_call.method_name)
    assert_equal([3], first_call.args)
    assert_equal({}, first_call.kwargs)
    assert_equal(%i[beep beep beep], first_call.return_value)

    assert_equal(@car, second_call.object)
    assert_equal(:honk, second_call.method_name)
    assert_equal([4], second_call.args)
    assert_equal({}, second_call.kwargs)
    assert_equal(%i[beep beep beep beep], second_call.return_value)
  end

  def test_multiple_methods
    skip

    calls =
      SpyHelper.spy_on(@car, methods: %i[honk drive]) do
        @car.honk(5)
        @car.drive
      end

    assert_equal 2, calls.length
    first_call = calls.first
    second_call = calls.last

    assert_equal(@car, first_call.object)
    assert_equal(:honk, first_call.method_name)
    assert_equal([5], first_call.args)
    assert_equal({}, first_call.kwargs)
    assert_equal(%i[beep beep beep beep beep], first_call.return_value)

    assert_equal(@car, second_call.object)
    assert_equal(:drive, second_call.method_name)
    assert_equal([], second_call.args)
    assert_equal({}, second_call.kwargs)
    assert_equal(:drive, second_call.return_value)
  end

  def test_any_instance
    skip

    @car1 = Car.new("Suzuki")
    @car2 = Car.new("Toyota")

    calls =
      SpyHelper.spy_on(Car, method: :honk, any_instance: true) do
        @car1.honk(5)
        @car2.honk(3)
      end

    assert_equal 2, calls.length
    first_call = calls.first
    second_call = calls.last

    assert_equal(@car1, first_call.object)
    assert_equal(:honk, first_call.method_name)
    assert_equal([5], first_call.args)
    assert_equal({}, first_call.kwargs)
    assert_equal(%i[beep beep beep beep beep], first_call.return_value)

    assert_equal(@car2, second_call.object)
    assert_equal(:honk, second_call.method_name)
    assert_equal([3], second_call.args)
    assert_equal({}, second_call.kwargs)
    assert_equal(%i[beep beep beep], second_call.return_value)
  end
end
