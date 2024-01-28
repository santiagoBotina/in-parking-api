module Merchants
  class Update < BusinessCore::Operation

    def initialize(merchants_repository: MerchantsRepository.new)
      @merchants_repository = merchants_repository
      super
    end

    step :get_merchant_by_email
    step :update_merchant

    private

    def get_merchant_by_email(input)
      email = input[:email]

      $logger.info "Merchants::Update::get_merchants_by_email - email: #{email}"


      user = @merchants_repository.get_one({email: email}).value_or(nil)
      if user.nil?
        Failure({
                  status: :not_found,
                  data: "Merchant with email: #{email} not found"
                })
      else
        Success(input.merge user: user)
      end
    end

    def update_merchant(input)
      $logger.info "Merchants::Update::update_merchant - input: #{input}"

      @merchants_repository.update(input)
    end
  end
end