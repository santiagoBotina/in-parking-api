module Auth
  class Login < BusinessCore::Operation
    def initialize(
      cognito_client: Aws::Cognito
    )
      @cognito_client = cognito_client
      super
    end

    step :validate_input
    step :authenticate

    def validate_input(input)
      $logger.info "Auth::Login::validate_input - input: #{input}"

      check_schema_validation Contracts::LoginSchema.call(input)
    end

    def authenticate(input)
      $logger.info "Auth::Login::authenticate - input: #{input}"

      auth_result = @cognito_client.authenticate(build_auth_object(input), input[:role])

      Success({status: :ok, data: auth_result})
    rescue Aws::CognitoIdentityProvider::Errors::UserNotFoundException
      $logger.error "Auth::Login::authenticate::ERROR - USER NOT FOUND"

      fail_with_bad_request('User not found')
    rescue Aws::CognitoIdentityProvider::Errors::NotAuthorizedException
      $logger.error "Auth::Login::authenticate::ERROR - NOT AUTHORIZED"

      fail_with_unauthorized('Not authorized')
    rescue Aws::CognitoIdentityProvider::Errors::UserNotConfirmedException
      $logger.error "Auth::Login::authenticate::ERROR - USER NOT CONFIRMED"

      fail_with_forbidden('User is not confirmed')
    rescue StandardError => e
      $logger.error "Auth::Login::authenticate::ERROR - unknown #{e}"

      fail_with_server_error('Something went wrong authenticating the user')
    end

    private

    def build_auth_object(input)
      $logger.info "Auth::Auth::build_auth_object - input: #{input}"

      {
        USERNAME: input[:email],
        PASSWORD: input[:password]
      }
    end

  end
end