require 'test_helper'

class WorkingHoursControllerTest < ActionController::TestCase
  setup do
    @working_hour = working_hours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:working_hours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create working_hour" do
    assert_difference('WorkingHour.count') do
      post :create, working_hour: { end: @working_hour.end, start: @working_hour.start, working_day_id: @working_hour.working_day_id, working_state: @working_hour.working_state }
    end

    assert_redirected_to working_hour_path(assigns(:working_hour))
  end

  test "should show working_hour" do
    get :show, id: @working_hour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @working_hour
    assert_response :success
  end

  test "should update working_hour" do
    patch :update, id: @working_hour, working_hour: { end: @working_hour.end, start: @working_hour.start, working_day_id: @working_hour.working_day_id, working_state: @working_hour.working_state }
    assert_redirected_to working_hour_path(assigns(:working_hour))
  end

  test "should destroy working_hour" do
    assert_difference('WorkingHour.count', -1) do
      delete :destroy, id: @working_hour
    end

    assert_redirected_to working_hours_path
  end
end
