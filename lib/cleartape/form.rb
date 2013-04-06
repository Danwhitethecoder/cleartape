# encoding: utf-8

require "cleartape/form/name"
require "cleartape/form/step"

module Cleartape
  class Form
    class NoStepsDefined < StandardError; end

    include ActiveAttr::Attributes
    include ActiveAttr::BlockInitialization
    include ActiveAttr::MassAssignment

    class_attribute :steps

    attr_reader :controller, :step, :params

    def initialize(controller, params = { })
      raise NoStepsDefined, "It makes no sense with one step only" if self.class.steps.blank?

      @controller = controller
      @params = params
      @step = params.delete(:step).try(:to_sym) || self.class.steps.first.name
    end

    def errors
      @errors || ActiveModel::Errors.new(self)
    end

    # Forms are never themselves persisted (yet)
    def persisted?
      false
    end

    def to_key
      nil
    end

    def to_param
      nil
    end

    # Define new step
    def self.step(name, &block)
      Step.new(name).tap do |step|
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

    def self.route_key(record_or_class)
      prevent_direct_use if [self.name, record_or_class.name].uniq.all? { |name| name == "Cleartape::Form" }

      # TODO this seemes hackish and may not be neccessary
      name = record_or_class.name
      name = self.name if name == "Cleartape::Form"

      # TODO handle record for update action
      ActiveSupport::Inflector.demodulize(name).sub(/Form$/, '').underscore.pluralize
    end

    def self.param_key(record_or_class)
      prevent_direct_use if [self.name, record_or_class.name].uniq.all? { |name| name == "Cleartape::Form" }

      # TODO this seemes hackish and may not be neccessary
      name = record_or_class.name
      name = self.name if name == "Cleartape::Form"

      # TODO handle record for update action
      ActiveSupport::Inflector.demodulize(name).sub(/Form$/, '').underscore
    end

    def to_partial_path
      [self.class.route_key(self.class), "form"].join("_")
    end

    def valid?
      # construct model stubs with correct validations for current step

      # validate

      # populate errors collection if not valid

      # return
      return true
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

  end
end
