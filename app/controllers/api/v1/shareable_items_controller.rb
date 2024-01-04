class Api::V1::ShareableItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_shareable_item, only: %i[ show update destroy ]
  
    # GET /api/shareable_items
    def index
      @shareable_items = ShareableItem.all
  
      render json: @shareable_items
    end
  
    # GET /api/shareable_items/1
    def show
      render json: @shareable_item
    end
  
    # POST /api/shareable_items
    def create
      @shareable_item = ShareableItem.new(hareable_item_params)
  
      if @shareable_item.save
        render json: @shareable_item, status: :created, item: @shareable_item
      else
        render json: @shareable_item.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /api/shareable_items/1
    def update
      if @shareable_item.update(shareable_item_params)
        render json: @shareable_item
      else
        render json: @shareable_item.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /api/shareable_items/1
    def destroy
      @shareable_item.destroy!
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_shareable_item
        @shareable_item = ShareableItem.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def shareable_item_params
        params.fetch(:hareable_item, {})
      end
  end
  