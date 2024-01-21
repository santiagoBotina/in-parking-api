module Users
  include BusinessCore
  include Aws
  class Create < BusinessCore::Operation

    def initialize(
      users_repository: UsersRepository.new,
      cognito_client: Aws::Cognito
    )
      @users_repository = users_repository
      @cognito_client = cognito_client
      super
    end

    step :validate_input
    step :validate_if_user_exists
    step :cognito_create_user
    step :persist_user

    def validate_input(input)
      $logger.info "Users::Create::validate_input - input: #{input}"

      check_schema_validation Contracts::CreateUserSchema.call(input)
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

      Success(input.merge cognito_id: sign_up_info[:user_sub])
    rescue Aws::CognitoIdentityProvider::Errors::UsernameExistsException
      $logger.error "Users::Create::cognito_create_user::ERROR - USERNAME ALREADY EXISTS"

      Failure({status: :bad_request, data: 'Username already exists'})
    rescue StandardError => e
      $logger.error "Users::Create::cognito_create_user::ERROR - unknown #{e}"

      Failure({status: :internal_server, data: 'Something went wrong creating the user'})
    end

    def persist_user(input)
      $logger.info "Users::Create::persist_user - input: #{input}"

      @users_repository.create(input)
    end

    private

    def user_exists_by_email(command)
      @users_repository.get_one(command).value_or(nil)
    end
  end
end