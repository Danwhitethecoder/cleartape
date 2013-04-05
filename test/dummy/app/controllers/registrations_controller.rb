class RegistrationsController < ApplicationController

  class RegistrationForm < Cleartape::Form
  end

  def new
    @form = RegistrationForm.new(self)
  end

  def create
    @form = RegistrationForm.new(self)
    @form.save

    redirect_to root_url
  end
end
