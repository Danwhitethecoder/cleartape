class RegistrationsController < ApplicationController

  class RegistrationForm < Cleartape::Form

    models :user, [:address, Address]

    step :user do |s|
      s.apply_validations :user, :name, :phone, :sex, :age
    end

    step :address do |s|
      s.apply_validations :address, :street_address, :city, :country, :postcode
    end

    def process
      return unless last_step?

      user = User.create!(self.user.attributes)
      address = Address.create!(self.user.attributes.merge(:user => user))
    end
  end

  def new
    @form = RegistrationForm.new(self)
  end

  def create
    @form = RegistrationForm.new(self, params)

    # binding.pry

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
