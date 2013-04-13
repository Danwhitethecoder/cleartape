require "test_helper"

class FormTest < ActiveSupport::TestCase

  class DummyForm < Cleartape::Form
    models :dummy

    step(:first) { }
    step(:second) { }
  end

  class DummiesController < ApplicationController; end

  include ActiveModel::Lint::Tests

  def model
    DummyForm.new(DummiesController.new)
  end

  def test_model_name
    assert_equal "FormTest::DummyForm", DummyForm.model_name
    assert_equal "Dummy", DummyForm.model_name.human
    assert_equal "dummy", DummyForm.model_name.singular
    assert_equal "dummies", DummyForm.model_name.plural
  end
end
