# encoding: utf-8

module Cleartape
  class Form

    class Step
      IGNORED_VALIDATIONS = [:uniqueness, :associated]

      attr_reader :name

      def initialize(name, model_definitions)
        @name = name.to_sym
        @model_definitions = model_definitions
        @faux_model_classes = Hash.new
      end

      def apply_validations(model_name, attributes)
        model_validators(model_name).select { |validator| (validator.attributes & attributes).present? }.each do |validator|
          next if IGNORED_VALIDATIONS.include?(validator.kind)

          validator.attributes.each do |attribute|
            faux_model_class(model_name).validates *validator.attributes, validator.kind => validator.options.dup || true
          end
        end
      end

      def validates(model_name, attributes, options)
        faux_model_class(model_name).validates(*attributes, options)
      end

      def faux_model_class(model_name)
        @faux_model_classes[model_name] ||= Model.derive(model_definition(model_name)[:class])
      end

      private

      def model_definition(model_name)
        @model_definitions.find { |definition| definition[:name] == model_name }
      end

      def model_validators(model_name)
        model_definition(model_name)[:class].validators
      end
    end

  end
end
