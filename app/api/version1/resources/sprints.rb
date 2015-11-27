require 'grape'

module API
  module Version1
    class Sprints < ::Grape::API
      version 'v1', using: :path

      resource :sprints do
        desc 'Returns sprints that are running or being closed', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        get '/' do
          authenticate_by_token!
          Sprint.where(state: ['running', 'closed'])
        end

        desc 'Returns daily rations by sprint with associated dish', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        get '/:id/daily_rations' do
          authenticate_by_token!
          DailyRation.includes(:dish)
            .where(user_id: current_user.id, sprint_id: params[:id])
            .as_json include: { dish: { only: :title } }
        end

        desc 'Creates order', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        params do
          requires :days, type: Hash do
            requires type: Hash, desc: "Dishes list filtered by days"
          end
        end

        post '/:id/daily_rations' do
          authenticate_by_token!
          { 'declared_params' => declared(params, include_missing: false) }
          save_order! Sprint.find(params[:id]) # Query Helper
        end

        desc 'Returns sprint by id', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        get '/:id' do
          authenticate_by_token!
          Sprint.find(params[:id])
        end
      end
    end
  end
end
