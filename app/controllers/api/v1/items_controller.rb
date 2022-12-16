class Api::V1::ItemsController < ApplicationController
  def index
    current_user_id = request.env["current_user_id"]
    return head 401 if current_user_id.nil?
    items = Item.where({ user_id: current_user_id })
      .where({ created_at: params[:created_after]..params[:created_before] })
      .page(params[:page])
    p items
    render json: {
             resources: items,
             pager: {
               page: params[:page] || 1,
               num: items.default_per_page,
               count: Item.count,
             },
           }, status: 200
  end

  def create
    # item = Item.new amount: params[:amount], tags_id: params[:tags_id], user_id: request.env['current_user_id'], happen_at: params[:happen_at]
    item = Item.new params.permit(:amount, :happen_at, tags_id: [])
    item.user_id = request.env["current_user_id"]
    if item.save
      render json: { resource: item }
    else
      render json: { errors: item.errors }, status: 422
    end
  end

  def summary
    hash = Hash.new
    items = Item.where({ user_id: request.env["current_user_id"] })
      .where({ created_at: params[:created_after]..params[:created_before] })
      .where(kind: params[:kind])
    items.each do |item|
      key = item.happen_at.in_time_zone('Beijing').strftime("%Y-%m-%d")
      hash[key] ||= 0
      hash[key] += item.amount
    end
    groups = hash.map { |k, v| { happen_at: k, amount: v } }
    groups.sort! { |a, b| a[:happen_at] <=> b[:happen_at] }
    render json: {
      groups: groups,
      total: items.sum(:amount),
    }
  end
end
