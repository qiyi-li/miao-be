class Api::V1::MesController < ApplicationController
  def show
    # 从header中拿到jwt
    jwt = request.headers["Authorization"].split(" ")[1] rescue ""

    payload = JWT.decode jwt, "my$ecretK3y", true, { algorithm: "HS256" } rescue nil
    if payload.nil?
      return head 400
    end

    user_id = payload[0]["user_id"] rescue nil
    user = User.find user_id

    if user.nil?
      return head 404
    else
      render json: { resource: user }
    end
  end
end
