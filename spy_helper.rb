# frozen_string_literal: true

module SpyHelper
  Call = Data.define(:object, :method_name, :args, :kwargs, :return_value)

  def self.spy_on(
    object,
    method: nil,
    methods: [method],
    any_instance: false,
    &outer_block
  )
    calls = []

    klass = any_instance ? object : object.singleton_class

    methods.each do |method_name|
      old_method_name = "old_#{method_name}".to_sym

      klass.alias_method old_method_name, method_name

      klass.define_method(method_name) do |*args, **kwargs, &block|
        return_value = send(old_method_name, *args, **kwargs, &block)
        calls.push(
          Call.new(object: self, method_name:, args:, kwargs:, return_value:)
        )
        return return_value
      end
    end

    outer_block.call

    methods.each do |method_name|
      old_method_name = "old_#{method_name}".to_sym
      klass.alias_method method_name, old_method_name
      klass.remove_method old_method_name
    end

    return calls
  end
end
