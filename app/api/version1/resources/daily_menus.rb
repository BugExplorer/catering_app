require 'grape'

module API
  module Version1
    class DailyMenus < ::Grape::API
      version 'v1', using: :path

      resource :daily_menus do
        desc '# Returns daily menus, where each day has categorized dishes', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        get '/' do
          # get FormModelsStorage
          FormModelsStorage.get_data
        end
      end
    end
  end
end
