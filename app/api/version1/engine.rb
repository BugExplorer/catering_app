require 'action_dispatch/middleware/remote_ip.rb'

module API
  module Version1
    autoload :Helpers,      'version1/resources/helpers'
    autoload :QueryHelpers,      'version1/resources/query_helpers'
    autoload :Sessions,     'version1/resources/sessions'
    autoload :Sprints,      'version1/resources/sprints'
    autoload :FormContents, 'version1/resources/form_contents'
    autoload :DailyMenus,   'version1/resources/daily_menus'

    class Engine < ::Grape::API
      format :json
      default_format :json
      default_error_formatter :json
      content_type :json, 'application/json'
      version 'v1', using: :path

      use ActionDispatch::RemoteIp

      helpers API::Version1::Helpers
      helpers API::Version1::QueryHelpers

      mount API::Version1::Sessions
      mount API::Version1::Sprints
      mount API::Version1::FormContents
      mount API::Version1::DailyMenus

      get '/' do
        { timenow: Time.zone.now.to_i }
      end
    end
  end
end
