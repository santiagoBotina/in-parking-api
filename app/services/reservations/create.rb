module Reservations
  include BusinessCore
  class Create < BusinessCore::Operation

    def initialize(
      reservations_repository: ReservationsRepository.new,
      get_user_by_id: Users::GetById.new
    )
      @reservations_repository = reservations_repository
      @get_user_by_id = get_user_by_id
      super
    end

    step :validate_input
    step :validate_if_user_exists
    step :create

    private

    def validate_input(input)
      $logger.info "Reservations::Create::validate_input - input: #{input}"

      check_schema_validation Contracts::ReservationSchema.call(input)
    end

    def validate_if_user_exists(input)
      $logger.info "Reservations::Create::get_user"

      user_id = input[:user_id]

      user = @get_user_by_id.call({ id: user_id }).value_or(nil)
      return Failure({ status: :not_found, data: "User with ID: #{user_id} not found" }) if user.nil?

      Success(input)
    end

    def create(input)
      $logger.info 'Reservations::Create::create'
      begin
        @reservations_repository.create(input)
      rescue StandardError => e
        $logger.info "Reservations::Create::create - error: #{e}"
      end
    end

  end
end
