class User < ApplicationRecord
  validates :email, presence: true
  def generate_jwt
    hmac_scret = 'my$ecretK3y'
    payload = {user_id: self.id, exp: (Time.now + 2.hours).to_i}
    token = JWT.encode payload , hmac_scret, 'HS256'
    return token
  end
  def generate_auth_header
    {Authorization: "Bearer #{self.generate_jwt}"}
  end
end