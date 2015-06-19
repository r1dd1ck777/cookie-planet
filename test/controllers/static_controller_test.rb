require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "should get index" do
    get :landing
    assert_response :success
  end

end
