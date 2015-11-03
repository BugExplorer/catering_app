require 'rails_helper'
describe API::Version1::Engine do
  describe 'GET /api/v1/sprints' do
    it 'returns list of all sprints' do
      FactoryGirl.create(:sprint, title: "Test sprint")

      get '/api/v1/sprints'
      expect(response.status).to eq 200
      expect(response.body).to have_node(:title).with("Test sprint")
    end

    it 'returns rations for specific sprint' do
      _sprint = FactoryGirl.create(:sprint)
      FactoryGirl.create(:daily_ration, sprint_id: _sprint.id, price: 12.3)

      get "/api/v1/sprints/#{_sprint.id}"
      expect(response.status).to eq 200
      expect(response.body).to have_node(:sprint_id).with(_sprint.id)
      expect(response.body).to have_node(:price).with(12.3)
    end
  end
end
