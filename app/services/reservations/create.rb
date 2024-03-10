module Reservations
  class Create < BusinessCore::Operation

    def initialize(
      reservations_repository: ReservationsRepository.new,
      get_user_by_id: Users::GetById.new,
      get_spot_by_id: Spots::GetById.new,
      payments_repository: PaymentsRepository.new
    )
      @reservations_repository = reservations_repository
      @get_spot_by_id = get_spot_by_id
      @get_user_by_id = get_user_by_id
      super
    end

    step :validate_input
    step :validate_if_user_exists
    step :validate_if_spot_is_available
    step :set_spot_as_reserved
    step :process_payment
    step :create_reservation

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

    def validate_if_spot_is_available(input)
      $logger.info "Reservations::Create::validate_if_spot_is_available"

      spot = @get_spot_by_id.call({ id: input[:spot_id] }).value_or(nil)

      return Failure({ status: :not_found, data: "Spot with ID: #{input[:spot_id]} not found" }) if spot.nil?
      return Failure({ status: :unprocessable, data: "Spot with ID: #{spot.id} is not available" }) if spot.available == false

      Success(input.merge spot: spot)
    end

    def set_spot_as_reserved(input)
      $logger.info "Reservations::Create::set_spot_as_reserved"

      spot = input[:spot]
      spot.update(available: false)

      Success(input)
    end

    def process_payment(input)
      $logger.info "Reservations::Create::process_payment - payment_created MOCK"
      Success(input)
    end

    def create_reservation(input)
      $logger.info 'Reservations::Create::create'
      begin
        @reservations_repository.create(input)
      rescue StandardError => e
        $logger.info "Reservations::Create::create - error: #{e}"
      end
    end

  end
end
