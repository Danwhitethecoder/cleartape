require "test_helper"

class Cleartape::Form::ModelTest < Cleartape::TestCase

  include ActiveModel::Lint::Tests

  class Dummy < Cleartape::Form::Model
  end

  def model
    Dummy.new
  end

end

