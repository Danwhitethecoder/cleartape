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


      def persisted?
        false
      end

    end
  end
end
