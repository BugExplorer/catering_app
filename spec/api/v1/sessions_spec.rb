require 'rails_helper'
describe API::Version1::Engine do
  let(:user) { FactoryGirl.create :user }

  describe 'POST /api/v1/sessions' do
    it do
      params = {
        email: user.email,
        password: user.password
      }
      post '/api/v1/sessions', params
      expect(response.status).to eq 201
      json = JSON.parse(response.body)
      expect(json).to include_json(
        auth_token: user.authentication_token, name: user.name
      )
    end
  end

  describe 'DELETE /api/v1/sessions' do
    let(:token) { user.authentication_token.to_s }
    it 'changes user token' do
      delete '/api/v1/sessions', nil,
             'X-Auth-Token' => user.authentication_token

      expect(response.status).to eq 200
      user.reload
      expect(user).not_to eq token
    end
  end
end
