class CountersController < ApplicationController
  before_action :set_counter, only: [:show, :edit, :update, :destroy]

  # GET /counters
  # GET /counters.json
  def index
    @counters = Counter.all
    @counter = Counter.new

  end

  # GET /counters/1
  # GET /counters/1.json
  def show
  end

  # GET /counters/new
  def new
    @counter = Counter.new
  end

  # GET /counters/1/edit
  def edit
  end

  # POST /counters
  # POST /counters.json
  def create

    set_selected_counter

    if @selected.present?
      total = @selected.actual + 1
      @selected.update(actual: total)

      @updated = set_selected_counter

    else
      @counter = Counter.new(counter_params)

    respond_to do |format|
      if @counter.save
        format.html { redirect_to @counter, notice: 'Counter was successfully created.' }
        format.json { render :show, status: :created, location: @counter }
      else
        format.html { render :new }
        format.json { render json: @counter.errors, status: :unprocessable_entity }
      end
    end
    end
    #
  end

  # PATCH/PUT /counters/1
  # PATCH/PUT /counters/1.json
  def update
    respond_to do |format|
      if @counter.update(counter_params)
        format.html { redirect_to @counter, notice: 'Counter was successfully updated.' }
        format.json { render :show, status: :ok, location: @counter }
      else
        format.html { render :edit }
        format.json { render json: @counter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /counters/1
  # DELETE /counters/1.json
  def destroy
    @counter.destroy
    respond_to do |format|
      format.html { redirect_to counters_url, notice: 'Counter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_selected_counter
      @selected = Counter.find_by("extract(hour from age(now(), created_at)) = 0 and engine_id = #{counter_params[:engine_id]} and reset = FALSE")
    end

    def set_counter
      @counter = Counter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def counter_params
      params.require(:counter).permit!
    end
end
