class Api::V1::ItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_item, only: %i[ show update destroy ]
  
    # GET /api/items
    def index
      @items = Item.accessible_by(current_ability, :read)
      render json: ItemSerializer.new(@items).serializable_hash
    end
  
    # GET /api/items/1
    def show
      authorize! :read, @item
      render json: ItemSerializer.new(@item).serializable_hash
    end
  
    # POST /api/items
    def create
      authorize! :create, Item
      @item = Item.new(hareable_item_params)
  
      if @item.save
        render json: @item, status: :created, item: @item
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /api/items/1
    def update
      authorize! :update, @item
      if @item.update(item_params)
        render json: @item
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /api/items/1
    def destroy
      authorize! :destroy, @item
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
  