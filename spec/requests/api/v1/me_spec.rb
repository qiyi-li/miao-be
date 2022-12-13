require "rails_helper"

RSpec.describe "Api::V1::Mes", type: :request do
  describe "获取当前用户" do
    it "登陆后成功获取userid" do
      user = User.create email: "errgou@gmail.com"
      post "/api/v1/session", params: { email: "errgou@gmail.com", code: "123456" }
      json = JSON.parse response.body
      jwt = json["jwt"]

      # 向me接口发送get请求，并且headers中在Authorization字段携带token
      get "/api/v1/me", headers: { "Authorization": "Bearer #{jwt}" }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json["resource"]["id"]).to eq user.id
    end
  end
end
