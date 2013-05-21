require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  include Rails.application.routes.url_helpers

  context "RegistrationsController" do
    context "on GET to :new" do
      should "respond with rendered form" do
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
                                                     :id => "registration_user_name",
                                                     :name => "registration[user][name]" }

        assert_tag :tag => "input", :attributes => { :type => "text",
                                                     :id => "registration_user_phone",
                                                     :name => "registration[user][phone]" }
      end
    end

    context "on POST to :create" do
      should "respond rendered form for invalid params" do
        user_attrs = {
          :name => "Zenon Benon",
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
        assert_equal user_attrs[:name], form.user.name
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
  end
end

