class Api::V1::MesController < ApplicationController
  def show
    user_id = request.env['current_user_id'] rescue nil
    user = User.find user_id
    if user.nil?
      return head 404
    else
      render json: { resource: user }
    end
  end
end
