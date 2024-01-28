module Auth
  class Create < BusinessCore::Operation
    def initialize(
      create_user: Users::Create.new,
      create_merchant: Merchants::Create.new
    )
      @create_user = create_user
      @create_merchant = create_merchant
      super
    end

    step :call_operation

    def call_operation(input)
      $logger.info "Auth::Create::call_operation - input: #{input}"

      role = input[:role]

      role === 'CONSUMER' ?
        @create_user.call(input) :
        @create_merchant.call(input)
    end
  end
end