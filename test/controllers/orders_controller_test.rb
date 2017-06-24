require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  test "should get catalog" do
    get :catalog
    assert_response :success
  end

  test "should get special" do
    get :special
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
