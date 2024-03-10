require_relative "boot"
require 'dry/monads/all'
require_relative "../lib/middleware/verify_token"

require "rails/all"
$logger ||= Logger.new(STDOUT)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module InParkingBack
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.autoload_lib(ignore: %w(lib))
    config.load_defaults 7.1

    config.autoload_paths += %W(#{config.root}/app/services)

    #auth token middleware
    #config.middleware.use Middleware::VerifyToken

    config.api_only = true
  end
end
