class Api::V1::UserLocationsController < ApplicationController
  before_action :set_location, only: %i[index update destroy]

  # GET /api/v1/locations/:location_id/users
  def index
    puts request.path
    authorize! :read, UserLocation.find(2)
    options = { include:  [:user] }
    render json: LocationUserSerializer.new(@location.user_locations, options).serializable_hash
  end
  
  # POST /api/v1/locations/:location_id/users/:id
  def create
  end

  # PATCH/PUT /api/v1/locations/:location_id/users/:id
  def update
    authorize! :update, @user_location
  end

  # DELETE /api/v1/locations/:location_id/users/:id
  def destroy
    authorize! :destroy, @user_location
    @user_location.destroy!
  end

  private

  def set_location
    @location = Location.find(params[:location_id])
    @user_location = UserLocation.find_by(location_id: params[:location_id], user_id: params[:id])
  end

  def current_user_location
    # current_user&.user_locations&.find { |user_location| user_location.location_id == @location.id }
  end
end
