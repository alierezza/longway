require 'test_helper'

class HeaderBoardsControllerTest < ActionController::TestCase
  setup do
    @header_board = header_boards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:header_boards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create header_board" do
    assert_difference('HeaderBoard.count') do
      post :create, header_board: { name: @header_board.name, order: @header_board.order, show: @header_board.show }
    end

    assert_redirected_to header_board_path(assigns(:header_board))
  end

  test "should show header_board" do
    get :show, id: @header_board
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @header_board
    assert_response :success
  end

  test "should update header_board" do
    patch :update, id: @header_board, header_board: { name: @header_board.name, order: @header_board.order, show: @header_board.show }
    assert_redirected_to header_board_path(assigns(:header_board))
  end

  test "should destroy header_board" do
    assert_difference('HeaderBoard.count', -1) do
      delete :destroy, id: @header_board
    end

    assert_redirected_to header_boards_path
  end
end
