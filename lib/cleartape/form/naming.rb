# encoding: utf-8

require "active_support/concern"
require "cleartape/form/name"

module Cleartape
  class Form
    module Naming
      extend ActiveSupport::Concern

      def form_name
        @form_name ||= self.class.model_name.singular
      end

      def to_key
        nil
      end

      def to_param
        nil
      end

      def to_partial_path
        self.class.partial_path(self.class)
      end

      module ClassMethods
        def model_name
          Name.build(self)
        end

        def route_key(record_or_class)
          prevent_direct_use if [self.name, record_or_class.name].uniq.all? { |name| name == "Cleartape::Form" }

          # TODO this seemes hackish and may not be neccessary
          name = record_or_class.name
          name = self.name if name == "Cleartape::Form"

          # TODO handle record for update action
          ActiveSupport::Inflector.demodulize(name).sub(/Form$/, '').underscore.pluralize
        end

        def param_key(record_or_class)
          prevent_direct_use if [self.name, record_or_class.name].uniq.all? { |name| name == "Cleartape::Form" }

          # TODO this seemes hackish and may not be neccessary
          name = record_or_class.name
          name = self.name if name == "Cleartape::Form"

          # TODO handle record for update action
          ActiveSupport::Inflector.demodulize(name).sub(/Form$/, '').underscore
        end

        def partial_path(record_or_class)
          [route_key(record_or_class), "form"].join("_")
        end

        def i18n_scope
          :cleartape
        end

        def lookup_ancestors
          [self]
        end

        def prevent_direct_use(exception_class = ArgumentError)
          fail exception_class, "Cleartape::Form must not be used directly but subclassed"
        end

      end
    end
  end
end
