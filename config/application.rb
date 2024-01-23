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

    config.middleware.use Middleware::VerifyToken
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
