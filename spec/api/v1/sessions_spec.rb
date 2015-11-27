require 'rails_helper'
describe API::Version1::Engine do
  let(:user) { FactoryGirl.create :user }

  describe 'POST /api/v1/sessions' do
    context 'when not authenticated' do
      it do
        params = {
          email: user.email + 'a',
          password: user.password + 'a'
        }
        post '/api/v1/sessions', params
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json['error_message']).to eq 'Invalid Email or Password.'
      end
    end

    context 'when authenticated' do
      it 'returns a new token' do
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
  end

  describe 'DELETE /api/v1/sessions' do
    let(:token) { user.authentication_token.to_s }

    context 'when not authenticated' do
      it do
        delete '/api/v1/sessions', nil,
               'X-Auth-Token' => 'Wrong token'
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json['message']).to eq 'Unauthenticated'
      end
    end

    context 'when authenticated' do
      it 'changes user token' do
        delete '/api/v1/sessions', nil,
               'X-Auth-Token' => user.authentication_token

        expect(response.status).to eq 200
        user.reload
        expect(user).not_to eq token
      end
    end
  end
end
