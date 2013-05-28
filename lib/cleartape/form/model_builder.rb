# encoding: utf-8

module Cleartape
  class Form
    class ModelBuilder

      attr_accessor :definitions, :instances

      def initialize
        @definitions = []
        @instances = {}
      end

      def instantiate_models(form)
        params = ActiveSupport::HashWithIndifferentAccess.new.update(form.params)
        step = form.class.steps.find { |s| s.name == form.step }
        definitions.each do |definition|
          model_name = definition[:name]
          model = step.faux_model_class(model_name).new
          instances[model_name] = model

          model_params = form.storage[model_name] || ActiveSupport::HashWithIndifferentAccess.new
          model_params = model_params.merge(params[form.form_name][model_name] || {}) if params.present?

          model.attributes = model_params

          yield model_name, model
        end
      end

      def models
        instances.values
      end

      def add(definition)
        definition = Array.wrap(definition)
        name, klass = definition
        klass ||= "::#{name.to_s.classify}".constantize

        # TODO add more specific constraints
        raise "Cannot determine class for :#{name} object" unless klass.is_a?(Class)

        definitions << {
          :name => name,
          :class => klass
        }

        return name
      end

    end
  end
end
