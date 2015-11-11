require "grape"

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
          Sprint.where(state: ['running', 'closed'])
        end

        desc 'Creates order', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        post '/:id/daily_rations' do
          authenticate_by_token!
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
