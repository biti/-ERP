require 'test_helper'

class DansControllerTest < ActionController::TestCase
  setup do
    @dan = dans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dan" do
    assert_difference('Dan.count') do
      post :create, dan: @dan.attributes
    end

    assert_redirected_to dan_path(assigns(:dan))
  end

  test "should show dan" do
    get :show, id: @dan.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dan.to_param
    assert_response :success
  end

  test "should update dan" do
    put :update, id: @dan.to_param, dan: @dan.attributes
    assert_redirected_to dan_path(assigns(:dan))
  end

  test "should destroy dan" do
    assert_difference('Dan.count', -1) do
      delete :destroy, id: @dan.to_param
    end

    assert_redirected_to dans_path
  end
end
