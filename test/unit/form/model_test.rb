require "test_helper"

class Form
  class ModelTest < ActiveSupport::TestCase

    include ActiveModel::Lint::Tests

    class Dummy < Cleartape::Form::Model
    end

    def model
      Dummy.new
    end

  end
end
