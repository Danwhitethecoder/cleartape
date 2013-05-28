# encoding: utf-8

require "cleartape/form/naming"
require "cleartape/form/step"
require "cleartape/form/model"
require "cleartape/form/model_builder"
require "cleartape/form/storage"

module Cleartape
  class Form
    class NoStepsDefined < StandardError; end

    include ActiveAttr::Attributes
    include ActiveAttr::BlockInitialization
    include ActiveAttr::MassAssignment

    extend ActiveModel::Translation

    include Cleartape::Form::Naming


    class_attribute :steps, :model_builder

    attr_reader :controller, :step, :params

    def initialize(controller, params = {})
      raise NoStepsDefined, "It makes no sense with one step only" if self.class.steps.blank?

      @controller = controller
      @params = params
      @step = storage[:__step__].try(:to_sym) || self.class.steps.first.name

      storage.data.merge!(params[form_name] || {})

      instantiate_models
    end

    def storage_key
      @storage_key ||= @params.blank? ? SecureRandom.hex : @params[form_name][:storage_key]
    end

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    # Forms are never themselves persisted (yet)
    def persisted?
      false
    end

    def self.models(*definitions)
      definitions.each { |definition| model(definition) }
    end

    def self.model(definition)
      self.model_builder ||= ModelBuilder.new
      name = self.model_builder.add(definition)
      attr_accessor(name)
    end

    # Define new step
    def self.step(name, &block)
      Step.new(name, model_builder.definitions).tap do |step|
        self.steps = [] if steps.nil?
        self.steps += [step]
        yield step
      end
    end

    def valid?
      valid = model_builder.models.all?(&:valid?)

      errors.clear
      model_builder.models.each do |model|
        model.errors.each do |attribute, attribute_errors|
          attribute_errors = Array.wrap(attribute_errors)
          attribute_errors.each do |error|
            errors.add :"#{model.class.name.demodulize.underscore}.#{attribute}", error
          end
        end
      end

      return valid
    end

    def save
      return false unless valid?
      if last_step?
        process
        storage.clear
        return true
      else
        advance
        return false
      end
    end

    def step?(name)
      step == name.to_sym
    end

    def last_step?
      step == self.class.steps.last.name
    end

    def storage
      Storage.new(self)
    end

    private

    def advance
      fail "Last step already reached!" if last_step?
      step_names = self.class.steps.map(&:name)
      idx = step_names.index(step)
      @step = storage[:__step__] = step_names[idx + 1]
    end

    def process
      raise NotImplementedError, "Form#process must be overriden by subclasses."
    end

    def instantiate_models
      self.class.model_builder.instantiate_models(self) do |name, instance|
        send("#{name}=", instance)
      end
    end
  end
end
