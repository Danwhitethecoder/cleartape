# encoding: utf-8

require "test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest
  context "Registration" do
    should "be successful" do
      visit new_registration_path

      assert page.has_content?("Name")
      assert page.has_content?("Phone")
      assert page.has_content?("Sex")
      assert page.has_content?("Age")

      page.within "#new_registration" do
        fill_in "registration[user][name]", :with => "Zenon Benon"
        fill_in "registration[user][phone]", :with => "600700800"
        fill_in "registration[user][age]", :with => "33"
        choose "registration_user_sex_male"
        click_button "Next"
      end

      assert_equal registrations_path, current_path
      assert page.has_content?("Street address")
      assert page.has_content?("City")

      page.within "#new_registration" do
        fill_in "registration[address][street_address]", :with => "Kwiatowa 666"
        fill_in "registration[address][city]", :with => "Knurów"
        fill_in "registration[address][country]", :with => "Polska"
        fill_in "registration[address][postcode]", :with => "30-000"
        click_button "Register"
      end

      assert_equal root_path, current_path
    end
  end
end
