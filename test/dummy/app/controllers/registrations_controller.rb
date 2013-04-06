class RegistrationsController < ApplicationController

  class RegistrationForm < Cleartape::Form

    attr_reader :user, :address

    step :user do |s|
    end

    step :address do |s|
    end

    def process
      # Do nothing for now
    end
  end

  def new
    @form = RegistrationForm.new(self)
  end

  def create
    @form = RegistrationForm.new(self, params)

    if @form.valid?
      @form.save

      if @form.last_step?
        redirect_to root_url
        return
      else
        @form.advance
      end

    end

    render :new
  end
end
