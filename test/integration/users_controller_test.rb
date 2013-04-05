require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Rails.application.routes.url_helpers

  def test_get_new_user
    get :new

    assert_template :new
    # assert
  end
end

