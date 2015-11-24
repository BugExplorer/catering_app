require 'grape'

module API
  module Version1
    class DailyMenus < ::Grape::API
      version 'v1', using: :path

      resource :daily_menus do
        desc 'Returns daily menus',
             headers: {
               'X-Auth-Token' => {
                 description: 'User token',
                 required: true
               }
             }

        get '/' do
          authenticate_by_token!
          DailyMenu.all
        end
      end
    end
  end
end
