require 'test_helper'

class DefectsControllerTest < ActionController::TestCase
  setup do
    @defect = defects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:defects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create defect" do
    assert_difference('Defect.count') do
      post :create, defect: { name: @defect.name, type: @defect.type }
    end

    assert_redirected_to defect_path(assigns(:defect))
  end

  test "should show defect" do
    get :show, id: @defect
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @defect
    assert_response :success
  end

  test "should update defect" do
    patch :update, id: @defect, defect: { name: @defect.name, type: @defect.type }
    assert_redirected_to defect_path(assigns(:defect))
  end

  test "should destroy defect" do
    assert_difference('Defect.count', -1) do
      delete :destroy, id: @defect
    end

    assert_redirected_to defects_path
  end
end
