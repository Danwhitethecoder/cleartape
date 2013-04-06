# encoding: utf-8

require "cleartape/form/name"

module Cleartape
  class Form

    include ActiveAttr::Attributes
    include ActiveAttr::BlockInitialization
    include ActiveAttr::MassAssignment

    attr_reader :controller

    def initialize(controller)
      @controller = controller
    end

    def errors
      @errors || ActiveModel::Errors.new(self)
    end

    # Forms are never themselves persisted
    def persisted?
      false
    end

    def to_key
      nil
    end

    def to_param
      nil
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
      return false
    end

    def save
      return false unless valid?
      process
      return true
    end

    private

    def process
      raise NotImplementedError, "Form#process must be overriden by subclasses."
    end
  end
end
