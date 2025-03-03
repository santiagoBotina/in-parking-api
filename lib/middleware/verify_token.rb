require 'byebug'

module Middleware
  class VerifyToken
    EXCLUDED_PATHS = %w[/users /auth/login /auth/confirm_sign_up /auth/sign_up].freeze
    AWS_VERIFY_TOKEN = "https://cognito-idp.#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['AWS_COGNITO_USERS_POOL_ID']}/.well-known/jwks.json"

    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)

      excluded_path?(request.path) ? @app.call(env) : verify_token(request, env)
    end

    private

    def verify_token(request, env)
      token = request.headers['HTTP_AUTHORIZATION']

      unless token
        error = { status: :unauthorized, data: 'Invalid or missing token' }

        return [
          401,
          { 'Content-Type' => 'application/json' },
          [error.to_json]
        ]
      end

      validation_result = validate_token(extract_token(token))

      return validation_result unless validation_result.nil?

      @app.call(env)
    end

    def validate_token(token)
      jwk_set = JSON.parse(Faraday.get(AWS_VERIFY_TOKEN).body)
      JWT.decode(token, nil, true, { jwks: jwk_set, algorithms: ['RS256'] })

      nil
    rescue JWT::ExpiredSignature
      fail_verification(403, { status: :unauthorized, data: 'Expired token' })
    rescue JWT::DecodeError => e
      fail_verification(403, { status: :unauthorized, data: 'Invalid token' })
    rescue StandardError => e
      fail_verification
    end

    def fail_verification(
      status_code = 500,
      response = {
        status: :internal_server_error,
        data: 'Something went wrong validating the token'
      }
    )
      [status_code, { 'Content-Type' => 'application/json' }, [response.to_json]]
    end

    def excluded_path?(path)
      EXCLUDED_PATHS.include?(path)
    end

    def extract_token(token)
      token.gsub("Bearer ", "")
    end
  end
end