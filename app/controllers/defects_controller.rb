class DefectsController < ApplicationController
  load_and_authorize_resource
  before_action :set_defect, only: [:show, :edit, :update, :destroy]

  # GET /defects
  # GET /defects.json
  def index
    @defects = Defect.all
  end

  # GET /defects/1
  # GET /defects/1.json
  def show
  end

  # GET /defects/new
  def new
    @defect = Defect.new
  end

  # GET /defects/1/edit
  def edit
  end

  # POST /defects
  # POST /defects.json
  def create
    @defect = Defect.new(defect_params)

    respond_to do |format|
      if @defect.save
        format.html { redirect_to defects_url, notice: 'Defect was successfully created.' }
        format.json { render :show, status: :created, location: @defect }
      else
        flash.now.alert = @defect.errors.full_messages.to_sentence
        format.html { render action: "new" }
        format.json { render json: @defect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /defects/1
  # PATCH/PUT /defects/1.json
  def update
    respond_to do |format|
      if @defect.update(defect_params)
        format.html { redirect_to defects_url, notice: 'Defect was successfully updated.' }
        format.json { render :show, status: :ok, location: @defect }
      else
        format.html { render :edit }
        format.json { render json: @defect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /defects/1
  # DELETE /defects/1.json
  def destroy
    @defect.destroy
    respond_to do |format|
      format.html { redirect_to defects_url, notice: 'Defect was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_defect
      @defect = Defect.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def defect_params
      params.require(:defect).permit!
    end
end
