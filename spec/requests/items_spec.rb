require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "index by page" do
    it "works! (now write some real specs)" do
      15.times do
        Item.create amount:1001
      end
      expect(Item.count).to eq(15)

      get '/api/v1/items?page=2'
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(5)

    end
  end
  describe "create" do
    it "can create an item" do
      expect{
        post '/api/v1/items',
        params:{amount:99}
      }.to change {Item.count}.by 1

      expect(response).to have_http_status 200
      json = JSON.parse response.body
      expect(json['resource']['id']).to be_an(Numeric)
      expect(json['resource']['amount']).to eq 99

    end
  end
end
