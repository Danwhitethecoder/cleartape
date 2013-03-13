require "test_helper"

class FormTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def model
    Cleartape::Form.new(nil)
  end
end
