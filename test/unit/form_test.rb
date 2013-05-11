require "test_helper"

class Cleartape::FormTest < Cleartape::TestCase

  include ActiveModel::Lint::Tests

  alias_method :model, :form

  def test_model_name
    assert_equal "Cleartape::TestCase::DummyForm", DummyForm.model_name
    assert_equal "Dummy", DummyForm.model_name.human
    assert_equal "dummy", DummyForm.model_name.singular
    assert_equal "dummies", DummyForm.model_name.plural
  end

  def test_model_attributes
    assert form.respond_to?(:user)
  end

  def test_first_step_validations
    assert_equal :name, form.step
    assert ! form.valid?, "Form should not be valid"
    assert form.user.errors[:name].present?, "There should be an error on :name attribute"
  end

end

