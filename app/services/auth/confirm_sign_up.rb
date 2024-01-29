module Auth
  class ConfirmSignUp < BusinessCore::Operation
    def initialize(
      cognito_client: Aws::Cognito,
      update_user_use_case: Users::Update.new,
      update_lessor_use_case: Lessors::Update.new
    )
      @cognito_client = cognito_client
      @update_user_use_case = update_user_use_case
      @update_lessor_use_case = update_lessor_use_case
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

      confirmation_result = @cognito_client.confirm_sign_up(input)

      return Failure(confirmation_result) if confirmation_result.has_key?(:error)

      Success(input)
    end

    def update_on_db(input)
      $logger.info "Auth::ConfirmSignUp::update_on_db - input: #{input}"

      input.merge! command: {
        status: 'ACTIVE',
        is_verified: true
      }

      role = input.delete :role

      role === 'CONSUMER' ?
        @update_user_use_case.call(input) :
        @update_lessor_use_case.call(input)
    end

  end
end