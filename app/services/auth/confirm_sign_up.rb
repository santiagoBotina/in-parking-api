module Auth
  include BusinessCore
  include Aws
  include Users

  class ConfirmSignUp < Operation
    def initialize(
      cognito_client: Aws::Cognito,
      update_user_use_case: Users::Update.new
    )
      @cognito_client = cognito_client
      @update_user_use_case = update_user_use_case
      super
    end

    step :validate_input
    step :confirm_sign_up
    step :update_on_db

    def validate_input(input)
      $logger.info "Auth::ConfirmSignUp::validate_input - input: #{input}"

      check_schema_validation Contracts::ConfirmSignUpSchema.call(input)
    end

    def confirm_sign_up(input)
      $logger.info "Auth::ConfirmSignUp::confirm_sign_up - input: #{input}"

      @cognito_client.confirm_sign_up(input)
    rescue Aws::CognitoIdentityProvider::Errors::CodeMismatchException
      $logger.error "Auth::ConfirmSignUp::confirm_sign_up::ERROR - CODE MISMATCH"

      Failure({status: :bad_request, data: 'Code mismatch'})
    rescue StandardError => e
      $logger.error "Auth::ConfirmSignUp::confirm_sign_up::ERROR - unknown #{e}"

      Failure({status: :internal_server, data: 'Something went wrong confirming the user'})
    end

    def update_on_db(input)
      $logger.info "Auth::ConfirmSignUp::update_on_db - input: #{input}"

      input.merge! command: {
        status: 'ACTIVE',
        is_verified: true
      }

      @update_user_use_case.call(input)
    end

  end
end