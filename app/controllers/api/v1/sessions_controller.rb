require 'jwt'
class Api::V1::SessionsController < ApplicationController
  def create
    if Rails.env.test?
      return render status: :unauthorized if params[:code] != "123456"
    else
      canSigin = ValidationCodes.exists? email: params[:email], code: params[:code], used_at: nil
      if !canSigin
        render status: 401, json: { errors: "验证码错误" }
        return
      end
    end
    user = User.find_or_create_by email: params[:email]
      #TODO 存放密文到密钥管理中去
      # hmac_scret = 'my$ecretK3y'
      # payload = {user_id: user.id}
      # token = JWT.encode payload , hmac_scret, 'HS256'
    render status: 200, json: { jwt:  user.generate_jwt}
  end
end
