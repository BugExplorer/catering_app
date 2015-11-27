require 'grape'

module API
  module Version1
    class Sessions < Grape::API
      version 'v1', using: :path
      format :json
      default_format :json
      default_error_formatter :json
      content_type :json, 'application/json'

      resource :sessions do
        desc 'Authenticate user and return user object / access token'

        params do
          requires :email, type: String, desc: 'User email'
          requires :password, type: String, desc: 'User Password'
        end

        post do
          { 'declared_params' => declared(params, include_missing: false) }
          email = params[:email]
          password = params[:password]

          if email.nil? || password.nil?
            error!({ error_code: 404,
                     error_message: 'Invalid Email or Password.' }, 401)
            return
          end

          user = User.where(email: email.downcase).first

          if user.nil?
            error!({ error_code: 404,
                     error_message: 'Invalid Email or Password.' }, 401)
            return
          end

          if user.valid_password?(password)
            user.save
            { auth_token: user.authentication_token,
              name: user.name }
          else
            error!({ error_code: 404,
                     error_message: 'Invalid Email or Password.' }, 401)
            return
          end
        end

        desc 'Destroy the access token', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        delete '/' do
          authenticate_by_token!
          current_user.reset_authentication_token
          current_user.save
        end
      end
    end
  end
end
