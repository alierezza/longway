class WorkingHoursController < ApplicationController
  load_and_authorize_resource except: :show
  before_action :set_working_hour, only: [:edit, :update, :destroy]
  add_breadcrumb "Working List", :working_hours_path

  # GET /working_hours
  # GET /working_hours.json
  def index
    @working_days = WorkingDay.all
  end

  # GET /working_hours/1
  # GET /working_hours/1.json
  def show
    @working_day = WorkingDay.find(params[:id])
    authorize! :show, @working_day
  end

  # GET /working_hours/new
  def new
    @working_day = WorkingDay.find(params[:working_day_id])
    @working_hour = @working_day.working_hours.new

    add_breadcrumb "Working Hours", working_hour_url(@working_day)
  end

  # GET /working_hours/1/edit
  def edit
    add_breadcrumb "Working Hours", working_hour_url(@working_day)
  end

  # POST /working_hours
  # POST /working_hours.json
  def create
    @working_day = WorkingDay.find(params[:working_day_id])
    @working_hour = @working_day.working_hours.new(working_hour_params)

    respond_to do |format|
      if @working_hour.save
        format.html { redirect_to working_hour_url(@working_day), notice: 'Working hour was successfully created.' }
        format.json { render :show, status: :created, location: @working_hour }
      else
        flash.now.alert = @working_hour.errors.full_messages.to_sentence
        format.html { render :new }
        format.json { render json: @working_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /working_hours/1
  # PATCH/PUT /working_hours/1.json
  def update
    respond_to do |format|
      if @working_hour.update(working_hour_params)
        format.html { redirect_to working_hour_url(@working_day), notice: 'Working hour was successfully updated.' }
        format.json { render :show, status: :ok, location: @working_hour }
      else
        flash.now.alert = @working_hour.errors.full_messages.to_sentence
        format.html { render :edit }
        format.json { render json: @working_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /working_hours/1
  # DELETE /working_hours/1.json
  def destroy
    @working_hour.destroy
    respond_to do |format|
      format.html { redirect_to working_hour_url(@working_day), notice: 'Working hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_working_hour
      @working_day = WorkingDay.find(params[:working_day_id])
      @working_hour = @working_day.working_hours.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def working_hour_params
      params.require(:working_hour).permit!
    end
end
