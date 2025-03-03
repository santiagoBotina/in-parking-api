module Reservations
  class Create < Core::Operation
    def initialize(
      reservations_repository: ReservationsRepository.new,
      users_repository: Users::UsersRepository.new,
      spots_repository: Spots::SpotsRepository.new,
      update_reservation_job: UpdateReservationJob
      #payments_repository: PaymentsRepository.new
    )
      @reservations_repository = reservations_repository
      @spots_repository = spots_repository
      @users_repository = users_repository
      @update_reservation_job = update_reservation_job
      super()
    end

    step :validate_input
    step :validate_if_spot_is_available
    step :persist_reservation

    private

    def validate_input(input)
      $logger.info "Reservations::Create::validate_input - input: #{input}"

      check_schema_validation Contracts::ReservationSchema.call(input)
    end

    def validate_if_spot_is_available(input)
      $logger.info "Reservations::Create::validate_id_spot_is_available"
      spot = @spots_repository
               .get_one_with_lock({id: input[:spot_id]})
               .value_or(nil)

      if spot.nil? || spot.status != 'AVAILABLE'
        return fail_with_bad_request('Spot is not available')
      end

      Success(input.merge spot: spot)
    end

    def persist_reservation(input)
      $logger.info "Reservations::Create::persist_reservation"
      reservation = @reservations_repository
                      .create(build_reservation(input)).value!

      Success({ status: :created, data: reservation })
    end

    def build_reservation(input)
      $logger.info "Reservations::Create::build_reservation"

      {
        user_id: input[:user_id],
        spot_id: input[:spot_id],
        lessor_id: input[:lessor_id],
        check_in: input[:check_in],
        check_out: input[:check_out],
        reservation_type: input[:reservation_type],
        vehicle_plate: input[:vehicle_plate],
      }
    end
  end
end
