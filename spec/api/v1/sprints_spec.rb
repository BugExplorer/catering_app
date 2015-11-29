require 'rails_helper'
describe API::Version1::Engine do
  let(:user) { FactoryGirl.create :user }
  let!(:sprint) { FactoryGirl.create(:sprint, title: 'Test sprint') }
  let!(:daily_ration) { FactoryGirl.create(:daily_ration, sprint: sprint) }

  describe 'GET /api/v1/sprints/:id' do
    context 'when not authenticated' do
      it do
        get "/api/v1/sprints/#{sprint.id}"
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json['message']).to eq 'Unauthenticated'
      end
    end

    context 'when authenticated' do
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
        expect(json['message']).to eq 'Unauthenticated'
      end
    end

    context 'when authenticated' do
      it do
        get '/api/v1/sprints', nil,
            'X-Auth-Token' => user.authentication_token
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET /api/v1/sprints/:id/daily_rations' do
    context 'when not authenticated' do
      it do
        get "/api/v1/sprints/#{sprint.id}/daily_rations"
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json['message']).to eq 'Unauthenticated'
      end
    end

    context 'when authenticated' do
      it do
        get "/api/v1/sprints/#{sprint.id}/daily_rations"
        get '/api/v1/sprints', nil,
            'X-Auth-Token' => user.authentication_token
        expect(response.status).to eq 200
      end
    end
  end

  describe 'POST /api/v1/sprints/:id/daily_rations' do
    context 'when not authenticated' do
      it do
        params = { days: { first: 'a' } }
        post "/api/v1/sprints/#{sprint.id}/daily_rations", params
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json['message']).to eq 'Unauthenticated'
      end
    end

    context 'when authenticated' do
      let!(:dish) { FactoryGirl.create(:single_meal) }
      let!(:daily_menu) { FactoryGirl.create(:daily_menu,
                                             dish_ids: [dish.id]) }

      it 'is invalid with wrong params' do
        params = {
          test: 'a',
          password: 122
        }
        post "/api/v1/sprints/#{sprint.id}/daily_rations", params,
            'X-Auth-Token' => user.authentication_token

        expect(response.status).to eq 422
      end

      it 'is saves daily rations' do
        FactoryGirl.create(:single_meal)

        params = {
          "days" => {
            daily_menu.id => { "0" =>
              {
                "dish_id"       => dish.id,
                "dish_price"    => dish.price,
                "quantity" => 1
              }
            }
          }
        }
        post "/api/v1/sprints/#{sprint.id}/daily_rations", params,
            'X-Auth-Token' => user.authentication_token

        expect(response.status).to eq 201
        expect(DailyRation.all).to include daily_ration
      end
    end
  end
end
