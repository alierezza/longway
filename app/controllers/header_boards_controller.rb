class HeaderBoardsController < ApplicationController
  load_and_authorize_resource
  before_action :set_header_board, only: [:show, :edit, :update, :destroy]

  # GET /header_boards
  # GET /header_boards.json
  def index
    if params[:visible]
      HeaderBoard.find(params[:id]).update!(visible: params[:visible])
    else
      @header_boards = HeaderBoard.rank(:order_no).all
    end
  end

  def update_row_order
    @header_board = HeaderBoard.find(params[:id])
    @header_board.order_no_position = params[:order_no_position]
    @header_board.save

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end

  # GET /header_boards/1
  # GET /header_boards/1.json
  def show
  end

  # GET /header_boards/new
  def new
    @header_board = HeaderBoard.new
  end

  # GET /header_boards/1/edit
  def edit
  end

  # POST /header_boards
  # POST /header_boards.json
  def create
    @header_board = HeaderBoard.new(header_board_params)

    respond_to do |format|
      if @header_board.save
        format.html { redirect_to header_boards_url, notice: 'Header board was successfully created.' }
        format.json { render :show, status: :created, location: @header_board }
      else
        format.html { render :new }
        format.json { render json: @header_board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /header_boards/1
  # PATCH/PUT /header_boards/1.json
  def update
    respond_to do |format|
      if @header_board.update(header_board_params)
        format.html { redirect_to header_boards_url, notice: 'Header board was successfully updated.' }
        format.json { render :show, status: :ok, location: @header_board }
      else
        format.html { render :edit }
        format.json { render json: @header_board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /header_boards/1
  # DELETE /header_boards/1.json
  def destroy
    @header_board.destroy
    respond_to do |format|
      format.html { redirect_to header_boards_url, notice: 'Header board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_header_board
      @header_board = HeaderBoard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def header_board_params
      params.require(:header_board).permit(:name, :name_vietnam, :visible, :order_no_position)
    end
end
