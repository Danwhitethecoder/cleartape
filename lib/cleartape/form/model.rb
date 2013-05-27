# encoding: utf-8

module Cleartape
  class Form
    class Model
      include ActiveAttr::Attributes
      include ActiveAttr::QueryAttributes
      # TODO defaults
      # TODO typecasts

      include ActiveAttr::Logger
      include ActiveAttr::MassAssignment
      # TODO mass assignment security / strong parameters

      extend ActiveModel::Naming

      include ActiveModel::Validations
      include ActiveModel::Dirty
      include ActiveModel::Conversion

      module Faux; end # Placeholder for faux model classes

      def self.derive(source_class)
        raise ArgumentError if source_class.nil?

        faux_class = Class.new(self)

        # FIXME redefinition of constants causes warnings
        # remove_const(source_class.name) if const_defined?(source_class.name)
        silence_warnings do
          Faux.const_set(source_class.name, faux_class) # Faux model needs a name for validations to work as expected
        end

        needless_attrs = %w(id created_at updated_at).map(&:to_sym)
        accessible_attrs = source_class.attribute_names.map(&:to_sym).reject { |attr| needless_attrs.include?(attr) }

        raise "No accessible attrs for :#{source_class} defined!" if accessible_attrs.blank?

        accessible_attrs.each { |attr| faux_class.attribute(attr) }

        return faux_class
      end

      def persisted?
        false
      end

    end
  end
end
