
module Cleartape
  class Form
    class Name < ActiveModel::Name
      def self.build(klass)
        # TODO fill in nils
        attributes = {
          :cache_key => nil,
          :collection => nil,
          :element => nil,
          :i18n_key => nil,
          :param_key => Form.param_key(klass),
          :partial_path => Form.new(nil).to_partial_path,
          :plural => nil,
          :route_key => Form.route_key(klass),
          :singular => nil,
          :singular_route_key => Form.route_key(klass).singularize
        }

        new(attributes)
      end

      def initialize(attributes)
        attributes.each { |name, value| instance_variable_set("@#{name}", value) }
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

    def self.route_key(record_or_class)
      # TODO handle record for update action
      ActiveSupport::Inflector.demodulize(record_or_class.name).sub(/Form$/, '').underscore.pluralize
    end

    def self.param_key(record_or_class)
      # TODO handle record for update action
      ActiveSupport::Inflector.demodulize(record_or_class.name).sub(/Form$/, '').underscore
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
