require 'grape'

module API
  module Version1
    class FormContents < ::Grape::API
      version 'v1', using: :path

      resource :form_contents do
        desc '# Returns daily menus, where each day has categorized dishes', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        get '/' do
          authenticate_by_token!
          FormContent.get_data
        end
      end
    end
  end
end
