module ApiAuthentication
  class AuthToken < Devise::Strategies::Authenticatable
    def valid?
      # true
      authentication_token
    end

    def authenticate!
      # User.first
      user = User.where(authentication_token: authentication_token).first
      user.nil? ? fail!('strategies.authentication_token.failed') : success!(user)
    end

    private

    def authentication_token
      request.headers['X-Auth-Token']
    end
  end
end
Warden::Strategies.add :api_authentication, ApiAuthentication::AuthToken
Devise.add_module :api_authentication, strategy: true
