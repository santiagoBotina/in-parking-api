module Merchants
  class Create < BusinessCore::Operation
    def initialize(
      merchants_repository: MerchantsRepository.new,
      cognito_client: Aws::Cognito
    )
      @merchants_repository = merchants_repository
      @cognito_client = cognito_client
      super
    end

    step :validate_input
    step :validate_if_merchant_exists
    step :cognito_create_merchant
    step :persist_merchant

    private

    def validate_input(input)
      $logger.info "Merchants::Create::validate_input - input: #{input}"

      check_schema_validation Contracts::CreateMerchantContract.call(input)
    end

    def validate_if_merchant_exists(input)
      $logger.info "Merchants::Create::validate_if_merchant_exists - input: #{input}"

      if merchant_exists_by_email({email: input[:email]})
        $logger.info "Merchants::Create::validate_if_merchant_exists - merchant EXISTS"
        return fail_with_conflict"merchant"
      end

      Success(input)
    end

    def cognito_create_merchant(input)
      $logger.info "Merchants::Create::cognito_create_merchant - input: #{input}"

      sign_up_info = @cognito_client.create_user(input)

      return Failure(sign_up_info) if sign_up_info.has_key?(:error)

      Success(input.merge cognito_id: sign_up_info[:user_sub])
    end

    def persist_merchant(input)
      $logger.info 'Merchants::Create::create'
      begin
        input.delete :role

        @merchants_repository.create(input)
      rescue StandardError => e
        $logger.info "Merchants::Create::create - error: #{e}"
      end
    end

    def merchant_exists_by_email(command)
      @merchants_repository.get_one(command).value_or(nil)
    end

  end
end