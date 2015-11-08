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

        desc 'Returns sprint by id', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        get '/:id' do
          Sprint.find(params[:id])
        end

        desc 'Returns daily rations for that sprint', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        get '/:id/rations' do
          DailyRation.where(sprint_id: params[:id])
        end
      end
    end
  end
end
