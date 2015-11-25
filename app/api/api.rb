require 'grape'
require 'warden'
require 'utils/logger'
require 'utils/failure_app'

module API
  class UnauthorizedError < StandardError; end
  class OrderError < StandardError; end

  module Version1
    autoload :Engine, 'version1/engine'
  end

  class Engine < ::Grape::API
    rescue_from Grape::Exceptions::Validation do |e|
      Rack::Response.new({'errors' => e.message, 'param' => e.param}.to_json,
                          422, {'Content-Type' => 'application/json'})
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      Rack::Response.new({'errors' => e.message}.to_json, 422,
                         {'Content-Type' => 'application/json'})
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      Rack::Response.new({'errors' => e.message,
                          'message' => 'RecordNotFound'}.to_json,
                          404, {'Content-Type' => 'application/json'})
    end

    rescue_from UnauthorizedError do |e|
      Rack::Response.new({'errors' => 'Invalid API public token',
                          'message' => 'Unauthorized'}.to_json,
                          401, {'Content-Type' => 'application/json'})
    end

    rescue_from OrderError do |e|
      Rack::Response.new({'errors' => "Order error",
                          'message' => "You can't order in this sprint"}.to_json,
                          400, {'Content-Type' => 'application/json'})
    end

    use API::Logger

    mount API::Version1::Engine
    # mount API::Version2::Engine
  end
end
