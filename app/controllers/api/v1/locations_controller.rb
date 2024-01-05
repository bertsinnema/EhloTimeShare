class Api::V1::LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: %i[ show update destroy ]

  # GET /api/locations
  def index
    @locations = Location.all

    render json: @locations
  end

  # GET /api/locations/1
  def show
    render json: @location
  end

  # POST /api/locations
  def create
    @location = Location.new(hareable_location_params)

    if @location.save
      render json: @location, status: :created, location: @location
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/locations/1
  def update
    if @location.update(location_params)
      render json: @location
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/locations/1
  def destroy
    @location.destroy!
  end


  # GET /api/locations/1/items
  def items
    @location = Location.find(params[:id])
    @items = @location.items
    render json: @items
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.fetch(:hareable_location, {})
    end
end
