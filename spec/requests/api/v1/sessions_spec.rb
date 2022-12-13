require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "会话" do
    it "登录（创建会话）" do
      User.create email: "errgou@gmail.com"
      post "/api/v1/session", params: { email: "errgou@gmail.com", code: "123456" }
      expect(response).to have_http_status(200)
      # print response.body
      json = JSON.parse response.body
      expect(json["jwt"]).to be_a(String)
    end
    it "首次登录" do
      post "/api/v1/session", params: { email: "errgou@gmail.com", code: "123456" }
      expect(response).to have_http_status(200)
      # print response.body
      json = JSON.parse response.body
      expect(json["jwt"]).to be_a(String)
    end
  end
end
