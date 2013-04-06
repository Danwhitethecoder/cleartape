# encoding: utf-8

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
  end
end
