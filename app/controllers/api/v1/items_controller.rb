class Api::V1::ItemsController < ApplicationController
    before_action :set_item, only: %i[ show update destroy ]
    before_action :set_location, only: %i[ index create ]
  
    # GET /api/v1/locations/:location_id/items
    def index
      authorize! :read, @location
      items = @location.items
      render json: ItemSerializer.new(items).serializable_hash
    end
  
    def show
      authorize! :read, @item
      render json: ItemSerializer.new(@item).serializable_hash
    end

    def create
      authorize! :create, Item.new({location_id: params[:location_id]})
      
      @item = Item.new(parsed_json_request[:attributes])
      # Assuming you have a `location` relationship
      location_data = parsed_json_request[:relationships]['location']['data']
      @item.location_id = location_data['id'] if location_data

      if @item.save
        render json: ItemSerializer.new(@item).serializable_hash, location: api_v1_location_item_path(@location, @item)
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    def update
      authorize! :update, @item
      if @item.update(parsed_json_request)
        render json: ItemSerializer.new(@item).serializable_hash, location: api_v1_location_item_path(@location, @item)
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    def destroy
      authorize! :destroy, @item
      render json: ItemSerializer.new(@item).serializable_hash
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_item
        @item = Item.find(params[:id])
      end

      def set_location
        @location = Location.find(params[:location_id])
      end

  end