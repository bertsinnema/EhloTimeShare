class Api::V1::ItemsController < ApplicationController
    before_action :set_item, only: %i[ show update destroy ]
    before_action :set_location, only: %i[ index ]
  
    # GET /api/v1/locations/:location_id/items
    def index
      authorize! :read, @location
      items = @location.items
      render json: ItemSerializer.new(items).serializable_hash
    end
  
    def show
    end

    def update
    end

    def destroy
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
  