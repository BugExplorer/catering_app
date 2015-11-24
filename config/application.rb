require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CateringApp
  class Application < Rails::Application
    config.generators do |g|
      g.template_engine :slim
      g.test_framework :rspec
      g.stylesheets false
      g.javascripts false
      g.helper_specs false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.middleware.insert_before 0, "Rack::Cors", debug: true, logger: (-> { Rails.logger }) do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options, :delete]
      end
    end

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
