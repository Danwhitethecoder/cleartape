
require "pry"

class RegistrationsController < ApplicationController

  class RegistrationForm < Cleartape::Form

    models :user, [:address, Address]

    step :user do |s|
      s.uses :user, :name, :phone, :sex, :age
    end

    step :address do |s|
      s.uses :address, :street_address, :city, :country, :postcode
    end

    def process
      return unless last_step?

      user = User.create!(self.user.attributes)
      address = Address.create!(self.address.attributes.merge(:user => user, :name => user.name))
    end
  end

  def new
    @form = RegistrationForm.new(self)
  end

  def create
    @form = RegistrationForm.new(self, params)

    if @form.save
      redirect_to root_url
      return
    end

    render :new
  end
end
