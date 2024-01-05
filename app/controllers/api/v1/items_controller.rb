class Api::V1::ItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_item, only: %i[ show update destroy ]
  
    # GET /api/items
    def index
      @items = Item.all
  
      render json: @items
    end
  
    # GET /api/items/1
    def show
      render json: @item
    end
  
    # POST /api/items
    def create
      @item = Item.new(hareable_item_params)
  
      if @item.save
        render json: @item, status: :created, item: @item
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /api/items/1
    def update
      if @item.update(item_params)
        render json: @item
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /api/items/1
    def destroy
      @item.destroy!
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_item
        @item = Item.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def item_params
        params.fetch(:hareable_item, {})
      end
  end
  