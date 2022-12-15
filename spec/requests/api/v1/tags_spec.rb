require "rails_helper"

RSpec.describe "Api::V1::Tags", type: :request do
  describe "获取标签" do
    it "未登录获取" do
      get "/api/v1/tags"
      expect(response).to have_http_status(401)
    end
    it "已登录获取" do
      user = User.create email: "1@qq.com "
      user2 = User.create email: "2@qq.com"
      get "/api/v1/tags", headers: user.generate_auth_header
      11.times do |i| Tag.create name: "tag#{i}", user_id: user.id, sign: "xxx" end
      11.times do |i| Tag.create name: "tag#{i}", user_id: user2.id, sign: "xxx" end

      get "/api/v1/tags", headers: user.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["resources"].size).to eq(10)

      get "/api/v1/tags?page=2", headers: user.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["resources"].size).to eq(1)
    end
  end
  describe "创建标签" do
    it "未登录创建" do
      post "/api/v1/tags", params: { name: "tag1", sign: "xxx" }
      expect(response).to have_http_status(401)
    end
    it "已登录创建" do
      user = User.create email: "1@qq.com"
      post "/api/v1/tags", params: { name: "tag1", sign: "x" }, headers: user.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["resource"]["name"]).to eq("tag1")
      expect(json["resource"]["sign"]).to eq("x")
    end
    it "已登录，无name创建" do
      user = User.create email: "1@qq.com"
      post "/api/v1/tags", params: { sign: "x" }, headers: user.generate_auth_header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["errors"]["name"][0]).to eq("can't be blank")
    end
    it "已登录，无sign创建" do
      user = User.create email: "1@qq.com"
      post "/api/v1/tags", params: { name: "x" }, headers: user.generate_auth_header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["errors"]["sign"][0]).to eq("can't be blank")
    end
  end
  describe "更新标签" do
    it "未登录更新" do
      user = User.create email: "1@qq.com"
      tag = Tag.create name: "tag1", sign: "x", user_id: user.id
      patch "/api/v1/tags/#{tag.id}", params: { name: "tag2" }
      expect(response).to have_http_status(401)
    end
    it "已登录更新" do
      user = User.create email: "1@qq.com"
      tag = Tag.create name: "tag1", sign: "x", user_id: user.id
      patch "/api/v1/tags/#{tag.id}", params: { name: "tag2" }, headers: user.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["resource"]["name"]).to eq("tag2")
      expect(json["resource"]["sign"]).to eq("x")
    end
  end
end
