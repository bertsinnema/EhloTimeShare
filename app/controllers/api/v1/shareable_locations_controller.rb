class Api::V1::ShareableLocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shareable_location, only: %i[ show update destroy ]

  # GET /api/shareable_locations
  def index
    @shareable_locations = ShareableLocation.all

    render json: @shareable_locations
  end

  # GET /api/shareable_locations/1
  def show
    render json: @shareable_location
  end

  # POST /api/shareable_locations
  def create
    @shareable_location = ShareableLocation.new(hareable_location_params)

    if @shareable_location.save
      render json: @shareable_location, status: :created, location: @shareable_location
    else
      render json: @shareable_location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/shareable_locations/1
  def update
    if @shareable_location.update(shareable_location_params)
      render json: @shareable_location
    else
      render json: @shareable_location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/shareable_locations/1
  def destroy
    @shareable_location.destroy!
  end


  # GET /api/shareable_locations/1/items
  def items
    @shareable_location = ShareableLocation.find(params[:id])
    @shareable_items = @shareable_location.shareable_items
    render json: @shareable_items
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shareable_location
      @shareable_location = ShareableLocation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shareable_location_params
      params.fetch(:hareable_location, {})
    end
end
