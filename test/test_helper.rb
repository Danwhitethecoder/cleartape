# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

require "pry"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

class Cleartape::TestCase < ActiveSupport::TestCase

  class DummyForm < Cleartape::Form
    models :user

    step(:name) do |step|
      step.validates :user, :name, :presence => true
    end

    step(:details) do |step|
      step.apply_validations :user, [:age, :sex, :phone]
    end
  end

  class DummiesController < ApplicationController; end

  def form
    @form ||= DummyForm.new(DummiesController.new)
  end

end
