class Api::V1::UserLocationsController < ApplicationController
  before_action :set_location, only: %i[index update destroy]

  # GET /api/v1/locations/:location_id/users
  def index
    authorize! :read, UserLocation.new({location_id: @location.id})
    options = { include:  [:user] }
    render json: LocationUserSerializer.new(@location.user_locations, options).serializable_hash
  end
  
  # POST /api/v1/locations/:location_id/users
  #TODO: create invite strategy
  def create
    authorize! :create, UserLocation.new({location_id: @location.id})
    @user_location = UserLocation.new(parsed_json_request);
    if @location.save
      render json: LocationUserSerializer.new(@user_location).serializable_hash
    else
      render json: @user_location.errors, status: :unprocessable_entity
    end    
  end

  # PATCH/PUT /api/v1/locations/:location_id/users/:id
  def update
    authorize! :update, @user_location
    if @user_location.update(parsed_json_request)
      render json: LocationUserSerializer.new(@user_location).serializable_hash
    else
      render json: @user_location.errors, status: :unprocessable_entity
    end    
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
end
