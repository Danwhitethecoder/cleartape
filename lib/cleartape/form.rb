# encoding: utf-8

require "cleartape/form/name"
require "cleartape/form/naming"
require "cleartape/form/step"
require "cleartape/form/model"

module Cleartape
  class Form
    class NoStepsDefined < StandardError; end

    include ActiveAttr::Attributes
    include ActiveAttr::BlockInitialization
    include ActiveAttr::MassAssignment

    include Cleartape::Form::Naming

    class_attribute :steps, :model_definitions

    attr_reader :controller, :step, :params

    def initialize(controller, params = { })
      raise NoStepsDefined, "It makes no sense with one step only" if self.class.steps.blank?

      @controller = controller
      @params = params
      @step = params.delete(:step).try(:to_sym) || self.class.steps.first.name

      define_models
      initialize_models(params) if params.present?
    end

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    # Forms are never themselves persisted (yet)
    def persisted?
      false
    end

    def self.models(*definitions)
      definitions.each do |definition|
        name = definition.respond_to?(:first) ? definition.first : definition
        klass = definition.respond_to?(:last) ? definition.last : nil

        self.model(name, klass)
      end
    end

    def self.model(name, klass = nil)
      klass ||= "::#{name.to_s.classify}".constantize

      # TODO add more specific constraints
      raise "Cannot determine class for :#{name} object" unless klass.is_a?(Class)

      self.model_definitions ||= []
      self.model_definitions += [{
        :name => name,
        :class => klass
      }]

      attr_accessor(name)
    end

    # Define new step
    def self.step(name, &block)
      Step.new(name, model_definitions).tap do |step|
        self.steps = [] if steps.nil?
        self.steps += [step]
        yield step
      end
    end

    def self.model_name
      Name.build(self)
    end

    def self.prevent_direct_use(exception_class = ArgumentError)
      fail exception_class, "Cleartape::Form must not be used directly but subclassed"
    end

    def valid?
      valid = models.all?(&:valid?)

      errors.clear
      models.each do |model|
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
      process
      return true
    end

    def step?(name)
      step == name.to_sym
    end

    def last_step?
      step == self.class.steps.last.name
    end

    def advance
      step_names = self.class.steps.map(&:name)
      idx = step_names.index(step)
      @step = step_names[idx + 1]
    end

    private

    def process
      raise NotImplementedError, "Form#process must be overriden by subclasses."
    end

    def define_models
      self.class.model_definitions.each do |definition|

        current_step = self.class.steps.find { |s| s.name == step }
        faux_class = current_step.faux_model_class(definition[:name])

        send("#{definition[:name]}=", faux_class.new)
      end
    end

    def initialize_models(params)
      params = ActiveSupport::HashWithIndifferentAccess.new.update(params)
      model_definitions.each do |definition|
        model = send("#{definition[:name]}")
        model.attributes = params[self.class.model_name.singular][definition[:name]]
      end
    end

    def models
      model_definitions.map { |definition| send("#{definition[:name]}") }
    end

  end
end
