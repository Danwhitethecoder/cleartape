# encoding: utf-8

require "test_helper"


class Cleartape::Form::StepTest < Cleartape::TestCase

  def test_apply_validations
    step = Cleartape::Form::Step.new(:email_step, [{ :name => :user, :class => ::User }])
    step.apply_validations(:user, [:email])

    validators = step.faux_model_class(:user).validators

    assert validators.present?, "Validators should be present"
    assert validators.all? { |validator| validator.attributes.include?(:email) }, "Found unexpected validators"
  end

  def test_apply_validations_with_options
    fail NotImplementedError.new
  end

  def test_validates
    step = Cleartape::Form::Step.new(:email_step, [{ :name => :user, :class => ::User }])
    step.validates(:user, :email, :length => { :minimum => 6 })

    validators = step.faux_model_class(:user).validators

    assert_equal 1, validators.size
    assert_equal ActiveModel::Validations::LengthValidator, validators.first.class
    assert_equal [:email], validators.first.attributes
  end

end

