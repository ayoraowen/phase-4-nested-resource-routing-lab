class ItemsController < ApplicationController

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def show
    item = Item.find(params[:id])#we use find instead of Item.find_by(id: params[:id]) which return nil. find_by would hv gone with if..else block commented out below
    # if item
      render json: item, include: :user
    # else
  rescue ActiveRecord::RecordNotFound
      render json: { error: "Item not found" }, status: :not_found
    # end
  end

  def create
    # if params[:user_id]
      # user = User.find(params[:user_id])
      item = Item.create!(item_params)
      # user.items << item
    
    # end
    render json: item, include: :user, status: :created
  rescue ActiveRecord::RecordInvalid => invalid
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

  private
  # all methods below here are private
  def item_params
    params.permit(:name, :description, :price)
  end

end