require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  test "should get special" do
    get :special
    assert_response :success
  end

  test "should get catalog" do
    get :catalog
    assert_response :success
  end

end
