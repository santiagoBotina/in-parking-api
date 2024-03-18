module Reservations
  class Create < BusinessCore::Operation
    def initialize(
      reservations_repository: ReservationsRepository.new,
      users_repository: Users::UsersRepository.new,
      spots_repository: Spots::SpotsRepository.new
      #payments_repository: PaymentsRepository.new
    )
      @reservations_repository = reservations_repository
      @spots_repository = spots_repository
      @users_repository = users_repository
      super
    end

    #TODO: refactor this to use a db transaction when updating the spot

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

      user = @users_repository.get_one({ id: user_id }).value_or(nil)
      return Failure({ status: :not_found, data: "User with ID: #{user_id} not found" }) if user.nil?

      Success(input)
    end

    def validate_if_spot_is_available(input)
      $logger.info "Reservations::Create::validate_if_spot_is_available"

      spot = @spots_repository.get_one({ id: input[:spot_id] }).value_or(nil)

      return Failure({ status: :not_found, data: "Spot with ID: #{input[:spot_id]} not found" }) \
        if spot.nil?

      return fail_with_bad_request("Spot with ID: #{input[:spot_id]} is not available") \
        if spot.status != 'AVAILABLE'

      Success(input.merge spot: spot)
    end

    def set_spot_as_reserved(input)
      $logger.info "Reservations::Create::set_spot_as_reserved"

      spot = input[:spot]
      spot.update(status: 'RESERVED')

      input.delete(:spot)

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
