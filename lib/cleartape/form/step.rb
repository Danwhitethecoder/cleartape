# encoding: utf-8

module Cleartape
  class Form

    class Step

      attr_reader :name

      def initialize(name)
        @name = name.to_sym
      end

      def apply_validations(model, attributes)
      end

      def validates(model, attributes, options)
      end

    end

  end
end
