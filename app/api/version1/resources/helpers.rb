module API
  module Version1
    module Helpers
      def warden
        env['warden']
      end

      def current_user
        warden.user || @user
      end

      def user_logged_in?
        !current_user.nil?
      end

      def authenticate_by_token!
        # return true if warden.authenticated?
        token = request.headers['X-Auth-Token']
        @user = User.find_by_authentication_token(token)
        fail UnauthorizedError unless token && @user
      end

      def client_ip
        env['action_dispatch.remote_ip'].to_s
      end
    end
  end
end
