module Users
  class Create < Core::Operation
    def initialize(
      users_repository: UsersRepository.new,
      cognito_factory: Aws::CognitoFactory
    )
      @users_repository = users_repository
      @cognito_factory = cognito_factory
      super()
    end

    step :validate_input
    map :get_cognito_client
    step :validate_if_user_exists
    step :cognito_create_user
    step :persist_user

    def validate_input(input)
      $logger.info "Users::Create::validate_input - input: #{input}"

      check_schema_validation Contracts::SignUpSchema.call(input)
    end

    def get_cognito_client(input)
      $logger.info "Users::Create::get_cognito_client - input: #{input}"

      @cognito_client ||= @cognito_factory.get_cognito

      input
    end

    def validate_if_user_exists(input)
      $logger.info "Users::Create::validate_if_user_exists - input: #{input}"

      if user_exists_by_email({email: input[:email]})
        $logger.info "Users::Create::validate_if_user_exists - user EXISTS"
        return fail_with_conflict("user")
      end

      Success(input)
    end

    def cognito_create_user(input)
      $logger.info "Users::Create::cognito_create_user - input: #{input}"

      sign_up_info = @cognito_client.create_user(input)

      return Failure(sign_up_info) if sign_up_info.has_key?(:error)

      Success(input.merge cognito_id: sign_up_info[:user_sub])
    end

    def persist_user(input)
      $logger.info "Users::Create::persist_user - input: #{input}"

      begin
        input.delete :role

        user = @users_repository.create(input).value!

        return Success({
          status: :created,
          data: user
        })
      rescue StandardError => e
        $logger.info "Users::Create::persist_lessor - error: #{e}"
      end
    end

    private

    def user_exists_by_email(command)
      $logger.info "Users::Create::user_exists_by_email - command: #{command}"

      @users_repository.get_one(command).value_or(nil)
    end
  end
end