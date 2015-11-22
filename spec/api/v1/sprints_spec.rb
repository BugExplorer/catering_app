require 'rails_helper'
describe API::Version1::Engine do
  let(:user) { FactoryGirl.create :user }
  let!(:sprint) { FactoryGirl.create(:sprint, title: 'Test sprint') }

  describe 'GET /api/v1/sprints/:id' do
    context 'when not authenticated' do
      it do
        get "/api/v1/sprints/#{sprint.id}"
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json['message']).to eq 'Unauthorized'
      end
    end

    context 'when authenticated' do
      let!(:first_sprint) { FactoryGirl.create(:sprint, title: 'First') }
      let!(:second_sprint) { FactoryGirl.create(:sprint, title: 'Second') }
      it 'returns a sprint by id' do
        get "/api/v1/sprints/#{sprint.id}", nil,
            'X-Auth-Token' => user.authentication_token
        expect(response.status).to eq 200
        expect(response.body).to eq sprint.to_json
      end
    end
  end

  describe 'GET /api/v1/sprints' do
    context 'when not authenticated' do
      it do
        get '/api/v1/sprints'
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json['message']).to eq 'Unauthorized'
      end
    end

    context 'when authenticated' do
      it do
        FactoryGirl.create(:sprint)
        get '/api/v1/sprints', nil,
            'X-Auth-Token' => user.authentication_token
        expect(response.status).to eq 200
      end
    end
  end
end
