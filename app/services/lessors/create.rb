module Lessors
  class Create < Core::Operation
    def initialize(
      lessors_repository: LessorsRepository.new,
      cognito_factory: AWS::CognitoFactory
    )
      @lessors_repository = lessors_repository
      @cognito_factory = cognito_factory
      super()
    end

    step :validate_input
    map :get_cognito_client
    step :validate_if_lessor_exists
    step :cognito_create_lessor
    step :persist_lessor

    private

    def validate_input(input)
      $logger.info "Lessors::Create::validate_input - input: #{input}"

      check_schema_validation Contracts::CreateLessorContract.call(input)
    end

    def get_cognito_client(input)
      $logger.info "Lessors::Create::get_cognito_client - input: #{input}"

      @cognito_client ||= @cognito_factory.get_cognito

      input
    end

    def validate_if_lessor_exists(input)
      $logger.info "Lessors::Create::validate_if_lessor_exists - input: #{input}"

      if lessor_exists_by_email({email: input[:email]})
        $logger.info "Merchants::Create::validate_if_lessor_exists - lessor EXISTS"
        return fail_with_conflict"merchant"
      end

      Success(input)
    end

    def cognito_create_lessor(input)
      $logger.info "Lessors::Create::cognito_create_lessor - input: #{input}"

      sign_up_info = @cognito_client.create_user(input)

      return Failure(sign_up_info) if sign_up_info.has_key?(:error)

      Success(input.merge cognito_id: sign_up_info[:user_sub])
    end

    def persist_lessor(input)
      $logger.info 'Lessors::Create::persist_lessor'
      begin
        input.delete :role

        lessor = @lessors_repository.create(input)

        return Success({
          status: :created,
          data: lessor
        })
      rescue StandardError => e
        $logger.info "Lessors::Create::persist_lessor - error: #{e}"
      end
    end

    def lessor_exists_by_email(command)
      @lessors_repository.get_one(command).value_or(nil)
    end
  end
end
