class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.where({ created_at: params[:created_after]..params[:created_before] }).page(params[:page]).per(params[:num])
    p items
    render json: {
             resources: items,
             pager: {
               page: params[:page],
               num: params[:num],
               count: Item.count,
             },
           }, status: 200
  end

  def create
    item = Item.new amount: params[:amount]
    if item.save
      render json: { resource: item }
    else
      render json: { errors: item.errors }
    end
  end
end
