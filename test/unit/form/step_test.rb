# encoding: utf-8

require "test_helper"


class Cleartape::Form::StepTest < Cleartape::TestCase

  context "Cleartape::Form::Step" do
    setup do
      @step = Cleartape::Form::Step.new(:email_step, [{ :name => :user, :class => ::User }])
    end

    should "allow to apply validations" do
      @step.apply_validations(:user, :email)

      validators = @step.faux_model_class(:user).validators

      assert validators.present?, "Validators should be present"
      assert validators.all? { |validator| validator.attributes.include?(:email) }, "Found unexpected validator for :email"
    end

    should "allow to ignore certain validations" do
      @step.apply_validations(:user, :age, :presence => false)

      validators = @step.faux_model_class(:user).validators

      assert validators.present?, "Validators should be present"
      assert validators.all? { |validator| validator.attributes.include?(:age) }, "Found unexpected validator for :age"
      assert validators.none? { |validator| :presence == validator.kind }, "Found unexpected :presence validator for :age"
    end

    should "allow to define custom validations" do
      @step.validates(:user, :email, :length => { :minimum => 6 })

      validators = @step.faux_model_class(:user).validators

      assert_equal 1, validators.size
      assert_equal ActiveModel::Validations::LengthValidator, validators.first.class
      assert_equal [:email], validators.first.attributes
    end
  end
end
