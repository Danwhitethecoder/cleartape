require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  include Rails.application.routes.url_helpers

  def test_get_to_new
    get :new

    assert_template :new

    form_tag_attributes = {
      :id => "new_registration",
      :class => "new_registration",
      :action => registrations_path,
      :method => "post"
    }

    assert_tag :tag => "form", :attributes => form_tag_attributes
    assert_tag :tag => "input", :attributes => { :type => "text",
                                                 :id => "registration_user_email",
                                                 :name => "registration[user][email]" }

    assert_tag :tag => "input", :attributes => { :type => "text",
                                                 :id => "registration_user_phone",
                                                 :name => "registration[user][phone]" }
  end

  def test_post_to_create
    user_attrs = {
      :email => "zenon.benon@example.com",
      :phone => "600600600",
      :sex => "male",
      :age => "51"
    }

    post :create, :registration => {
      :step => "user",
      :user => user_attrs
    }

    form = assigns(:form)

    assert_equal :address, form.step
    assert_equal user_attrs[:email], form.user.email
    assert_equal user_attrs[:phone], form.user.phone


    assert_template :new

    assert_tag :tag => "input", :attributes => { :type => "text",
                                                 :id => "registration_address_street_address",
                                                 :name => "registration[address][street_address]" }

    assert_tag :tag => "input", :attributes => { :type => "text",
                                                 :id => "registration_address_city",
                                                 :name => "registration[address][city]" }
  end
end

