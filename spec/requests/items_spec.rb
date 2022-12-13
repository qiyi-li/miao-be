require "rails_helper"

RSpec.describe "Items", type: :request do
  describe "获取账目" do
    it "分页" do
      15.times do
        Item.create amount: 1001
      end
      expect(Item.count).to eq(15)

      get "/api/v1/items?page=2"
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      expect(json["resources"].size).to eq(5)
    end
    it "按时间筛选" do
      item1 = Item.create amount: 1001, created_at: Time.new(2017, 01, 02)
      item2 = Item.create amount: 1002, created_at: Time.new(2018, 01, 01)
      get "/api/v1/items?create_after=2017-01-01&created_before=2017-01-03"
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["resources"].size).to eq(1)
      expect(json["resources"][0]["id"]).to eq(item1.id)

    end
  end
  describe "create" do
    it "can create an item" do
      expect {
        post "/api/v1/items",
             params: { amount: 99 }
      }.to change { Item.count }.by 1

      expect(response).to have_http_status 200
      json = JSON.parse response.body
      expect(json["resource"]["id"]).to be_an(Numeric)
      expect(json["resource"]["amount"]).to eq 99
    end
  end
end
