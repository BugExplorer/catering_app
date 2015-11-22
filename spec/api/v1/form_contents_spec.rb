require 'rails_helper'
describe API::Version1::Engine do
  let(:user) { FactoryGirl.create :user }

  describe 'GET /api/v1/form_contents' do
    context 'when not authenticated' do
      it do
        get '/api/v1/form_contents'
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json['message']).to eq 'Unauthorized'
      end
    end

    context 'when authenticated' do
      it do
        get '/api/v1/form_contents', nil,
            'X-Auth-Token' => user.authentication_token
        expect(response.status).to eq 200
      end
    end
  end
end
