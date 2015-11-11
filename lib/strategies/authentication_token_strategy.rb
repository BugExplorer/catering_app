class AuthenticationTokenStrategy < ::Warden::Strategies::Base

  def valid?
    authentication_token
  end

  def authenticate!
    user = User.where(authentication_token: authentication_token).first
    user.nil? ? fail!('strategies.authentication_token.failed') : success!(user)
  end

  private

  def authentication_token
    request.headers['X-Auth-Token']
  end

    # send a 400 back to the client: bad request
    # This will also halt warden from allowing any other strategies to continue.
    # def deny!
    #   body = %(This is an unauthorised request.)
    #   response_headers = { 'Content-Type' => 'text/plain' }
    #   response = Rack::Response.new(body, 400, response_headers)
    #   custom! response.finish
    # end

end

# Warden::Strategies.add :token_auth, TokenAuth::TokenStrategy

# Devise.add_module :token_auth, :strategy => true

