class Api::V1::LocationsController < ApplicationController
  before_action :set_location, only: %i[ show update destroy items users ]

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
    @location = Location.new(parsed_json_request)
    @location.save
    @location.user_locations.create(user: current_user, role: "owner")

    if @location.save
      render json: LocationSerializer.new(@location).serializable_hash, status: :created, location: api_v1_location_path(@location.id)
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/locations/1
  def update
    authorize! :update, @location
    if @location.update(location_params)
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


  # GET /api/v1/locations/1/items
  def items
    authorize! :read, Item
    @items = @location.items
    render json: ItemSerializer.new(@items).serializable_hash
  end

  # GET /api/v1/locations/:id/users
  def users
    authorize! :edit, @location
    @users = @location.users.includes(:user_locations)
    render json: LocationUserSerializer.new(@users,{params: { location_id: @location.id }}).serializable_hash
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end
end
