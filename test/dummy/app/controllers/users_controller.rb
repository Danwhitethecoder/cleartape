class UsersController < ApplicationController
  class UserForm < Cleartape::Form; end

  def new
    @form = UserForm.new(self)
  end

  def create
    @form = UserForm.new(self)
    @form.save

    redirect_to root_url
  end
end
