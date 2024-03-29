class Api::V1::LocationsController < ApplicationController
  before_action :set_location, only: %i[ show update destroy ]

  # GET /api/v1/locations
  def index
    @locations = Location.accessible_by(current_ability, :read)
    render json: LocationSerializer.new(@locations).serializable_hash
  end

  # GET /api/v1/locations/1
  def show
    authorize! :read, @location
    render json: LocationSerializer.new(@location).serializable_hash
  end

  # POST /api/v1/locations
  def create
    authorize! :create, Location
    @location = Location.new(parsed_json_request[:attributes])
    
    if @location.save && @location.user_locations.create(user: current_user, role: "owner")
      render json: LocationSerializer.new(@location).serializable_hash, status: :created, location: api_v1_location_path(@location.id)
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/locations/1
  def update
    authorize! :update, @location
    if @location.update(parsed_json_request[:attributes])
      render json: LocationSerializer.new(@location).serializable_hash, location: api_v1_location_path(@location.id)
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/locations/1
  def destroy
    authorize! :destroy, @location
    @location.destroy!
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end
end
