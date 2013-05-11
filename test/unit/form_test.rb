require "test_helper"

class FormTest < ActiveSupport::TestCase

  class DummyForm < Cleartape::Form
    models :user

    step(:email) do |step|
      step.validates :user, :email, :presence => true
    end

    step(:details) do |step|
      step.apply_validations :user, [:email, :phone]
    end
  end

  class DummiesController < ApplicationController; end

  include ActiveModel::Lint::Tests

  def model
    @form ||= DummyForm.new(DummiesController.new)
  end
  alias_method :form, :model

  def test_model_name
    assert_equal "FormTest::DummyForm", DummyForm.model_name
    assert_equal "Dummy", DummyForm.model_name.human
    assert_equal "dummy", DummyForm.model_name.singular
    assert_equal "dummies", DummyForm.model_name.plural
  end

  def test_model_attributes
    assert form.respond_to?(:user)
  end

  def test_first_step_validations
    assert_equal :email, form.step
    assert ! form.valid?, "Form should not be valid"
    assert form.user.errors[:email].present?, "There should be an error on :email attribute"
  end
end
