# encoding: utf-8

module Cleartape
  class Form
    class Storage
      def initialize(form)
        @form_name = form.form_name
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

      # TODO should allow for deep merge
      def update(params)
        params = params[@form_name] || {}
        params.each do |model_name, model_params|
          data[model_name] ||= ActiveSupport::HashWithIndifferentAccess.new
          data[model_name].merge!(model_params) if model_params.is_a?(Hash)
        end
      end
    end
  end
end
