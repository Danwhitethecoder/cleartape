# encoding: utf-8

require "test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest

  def fill_in_all(step, values)
    values.each { |attr, value| fill_in "registration[#{step}][#{attr}]", :with => value }
  end

  context "Registration" do
    should "be successful" do
      visit new_registration_path
      assert page.has_content?("User details")

      page.within "#new_registration" do
        fill_in_all :user, :name => "Zenon Benon",
                           :phone => "600700800",
                           :age => "33"
        choose "registration_user_sex_male"
        click_button "Next"
      end

      assert_equal registrations_path, current_path
      assert page.has_content?("User address")

      page.within "#new_registration" do
        fill_in_all :address, :street_address => "Kwiatowa 666",
                              :city => "Knurów",
                              :country => "Polska",
                              :postcode => "300-00"
        click_button "Register"
      end

      assert_equal root_path, current_path
    end

    should "show validation messages in case of validation errors" do
      visit new_registration_path
      assert page.has_content?("User details")

      page.within "#new_registration" do
        click_button "Next"
      end

      assert_equal registrations_path, current_path

      assert page.has_content?("User details")
      assert ! page.has_content?("User address")

      assert page.has_content?("Name can't be blank")
      assert page.has_content?("Phone number can't be blank")
      assert page.has_content?("Sex is not included in the list")
      assert page.has_content?("Age can't be blank")
      assert page.has_content?("Age is not a number")
    end

    should "preserve user input in case of validation errors" do
      visit new_registration_path
      assert page.has_content?("User details")

      page.within "#new_registration" do
        fill_in_all :user, :name => "Zenon Benon"
        choose "registration_user_sex_male"
        click_button "Next"
      end

      assert_equal registrations_path, current_path

      assert page.has_content?("User details")
      assert ! page.has_content?("User address")

      page.within "#new_registration" do
        assert has_field?("registration[user][name]", :with => "Zenon Benon")
        assert has_checked_field?("registration_user_sex_male")
      end
    end
  end
end
