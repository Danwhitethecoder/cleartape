require "test_helper"

class Cleartape::FormTest < Cleartape::TestCase

  include ActiveModel::Lint::Tests

  alias_method :model, :form

  context "Cleartape::Form" do
    should "have sensible naming" do
      assert_equal "Cleartape::TestCase::DummyForm", DummyForm.model_name
      assert_equal "Dummy", DummyForm.model_name.human
      assert_equal "dummy", DummyForm.model_name.singular
      assert_equal "dummies", DummyForm.model_name.plural
    end

    should "respond to defined model names" do
      assert form.respond_to?(:user)
    end

    should "validate input and populate errors" do
      assert_equal :name, form.step
      assert ! form.valid?, "Form should not be valid"
      assert form.user.errors[:name].present?, "There should be an error on :name attribute"
    end
  end

end

