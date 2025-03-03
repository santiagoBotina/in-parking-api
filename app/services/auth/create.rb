module Auth
  class Create < Core::Operation
    def initialize(
      create_user: Users::Create.new,
      create_lessor: Lessors::Create.new
    )
      @create_user = create_user
      @create_lessor = create_lessor
      super()
    end

    step :call_operation

    def call_operation(input)
      $logger.info "Auth::Create::call_operation - input: #{input}"

      role = input[:role]

      role === 'CONSUMER' ?
        @create_user.call(input) :
        @create_lessor.call(input)
    end
  end
end