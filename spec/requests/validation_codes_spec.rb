require "rails_helper"

RSpec.describe "ValidationCodes", type: :request do
  describe "验证码" do
    it "发送太频繁会返回429" do
      post "/api/v1/validation_codes", params: { email: "errgou@gmail.com" }
      expect(response).to have_http_status(200)
      post "/api/v1/validation_codes", params: { email: "errgou@gmail.com" }
      expect(response).to have_http_status(429)
    end
    it "无效的邮箱会返回422" do
      post "/api/v1/validation_codes", params: { email: "11" }
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["errors"]["email"][0]).to eq("格式不正确")
    end
  end
end
