module Lessors
  class Update < Core::Operation

    def initialize(lessors_repository: LessorsRepository.new)
      @lessors_repository = lessors_repository
      super()
    end

    step :get_lessor_by_email
    step :update_lessor

    private

    def get_lessor_by_email(input)
      email = input[:email]

      $logger.info "Lessors::Update::get_lessors_by_email - email: #{email}"


      user = @lessors_repository.get_one({email: email}).value_or(nil)
      if user.nil?
        Failure({
                  status: :not_found,
                  data: "Lessor with email: #{email} not found"
                })
      else
        Success(input.merge user: user)
      end
    end

    def update_lessor(input)
      $logger.info "Lessors::Update::update_lessor - input: #{input}"

      @lessors_repository.update(input)
    end
  end
end