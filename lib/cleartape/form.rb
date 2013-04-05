
module Cleartape
  class Form
    class Name < ActiveModel::Name
      def self.build(klass)
        partial_path = klass.new(nil).to_partial_path    # => 'foos_form'
        param_key = klass.param_key(klass)               # => 'foo'
        route_key = klass.route_key(klass)               # => 'foos'
        singular = param_key

        attributes = {
          :element => singular,
          :collection => singular.pluralize,
          :param_key => param_key,
          :partial_path => partial_path,
          :route_key => route_key,
          :i18n_key => "#{singular}_form".to_sym,
          :cache_key => partial_path,
          :singular => singular,
          :singular_route_key => route_key.singularize,
          :plural => singular.pluralize
        }

        new(klass, attributes)
      end

      def initialize(klass, attributes)
        self << klass.name
        attributes.each { |name, value| instance_variable_set("@#{name}", value) }
      end

      def human(options = {})
        # TODO implement i18n
        singular.capitalize
      end
    end

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
