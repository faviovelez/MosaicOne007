require 'test_helper'

class ManagersControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get tray1" do
    get :tray1
    assert_response :success
  end

  test "should get tray2" do
    get :tray2
    assert_response :success
  end

  test "should get tray3" do
    get :tray3
    assert_response :success
  end

end
