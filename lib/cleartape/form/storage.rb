# encoding: utf-8

module Cleartape
  class Form
    class Storage
      def initialize(form)
        @form_name = form.class.model_name.singular
        @storage_key = form.storage_key
        @session = form.controller.session
      end

      def [](key)
        data[key]
      end

      def []=(key, value)
        data[key] = value
      end

      def data
        @session[:"__cleartape_#{@storage_key}__"] ||= {}
        @session[:"__cleartape_#{@storage_key}__"][@form_name] ||= ActiveSupport::HashWithIndifferentAccess.new
        return @session[:"__cleartape_#{@storage_key}__"][@form_name]
      end

      def clear
        @session.delete(:"__cleartape_#{@storage_key}__")
      end
    end
  end
end
