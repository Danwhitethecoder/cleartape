require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  include Rails.application.routes.url_helpers

  def test_get_new_registration
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
end

