class Api::V1::LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: [:users]
  before_action :set_location, only: %i[ show update destroy ]

  # GET /api/v1/locations
  def index
    # Get locations that are public or where the user is a member
    @locations = Location
    .joins(:user_locations)
    .where('locations.public = ? OR user_locations.user_id = ?', true, current_user.id)
    .distinct

    render json: LocationSerializer.new(@locations).serializable_hash
  end

  # GET /api/v1/locations/1
  def show
    render json: LocationSerializer.new(@location).serializable_hash
  end

  # POST /api/v1/locations
  def create
    @location = Location.new(hareable_location_params)

    if @location.save
      render json: LocationSerializer.new(@location).serializable_hash, status: :created, location: @location
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/locations/1
  def update
    if @location.update(location_params)
      render json: LocationSerializer.new(@location).serializable_hash
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/locations/1
  def destroy
    @location.destroy!
  end


  # GET /api/v1/locations/1/items
  def items
    @location = Location.find(params[:id])
    @items = @location.items
    render json: ItemSerializer.new(@items).serializable_hash
  end

  # GET /api/v1/locations/:id/users
  def users
    @location = Location.find(params[:id])
    @users = @location.users.includes(:user_locations)

    render json: LocationUserSerializer.new(@users,{params: { location_id: @location.id }}).serializable_hash
  end

  private

    def authorize_user
      # Retrieve the location
      @location = Location.find(params[:id])

      # Check if the current user has the required role in the location
      unless current_user_has_required_role?
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end

    def current_user_has_required_role?
      # Check if the current user has the required role in the location
      # You may need to adjust this based on your actual implementation
      user_location = current_user.user_locations.find_by(location_id: @location.id)
      user_location&.role.in?(%w[owner manager])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.fetch(:hareable_location, {})
    end
end
