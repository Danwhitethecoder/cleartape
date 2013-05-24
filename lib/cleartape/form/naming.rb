# encoding: utf-8

require "active_support/concern"

module Cleartape
  class Form
    module Naming
      extend ActiveSupport::Concern

      def to_key
        nil
      end

      def to_param
        nil
      end

      def to_partial_path
        [self.class.route_key(self.class), "form"].join("_")
      end

      module ClassMethods
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
      end
    end
  end
end
