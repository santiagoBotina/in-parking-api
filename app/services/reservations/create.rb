module Reservations
  class Create < BusinessCore::Operation
    def initialize(
      reservations_repository: ReservationsRepository.new,
      users_repository: Users::UsersRepository.new,
      spots_repository: Spots::SpotsRepository.new,
      create_reservation_job: CreateReservationJob
      #payments_repository: PaymentsRepository.new
    )
      @reservations_repository = reservations_repository
      @spots_repository = spots_repository
      @users_repository = users_repository
      @create_reservation_job = create_reservation_job
      super
    end

    step :validate_input
    step :persist_reservation
    step :validate_payment
    tee :enqueue_reservation
    map :serialize

    private

    def validate_input(input)
      $logger.info "Reservations::Create::validate_input - input: #{input}"

      check_schema_validation Contracts::ReservationSchema.call(input)
    end

    def validate_id_spot_is_available(input)
      $logger.info "Reservations::Create::validate_id_spot_is_available"
      spot = @spots_repository.get_one_with_lock({id: input[:spot_id]})

      if spot.nil? || spot.status != 'AVAILABLE'
        Failure(:spot_not_available)
      end

      Success(input.merge spot: spot)
    end

    def persist_reservation(input)
      $logger.info "Reservations::Create::persist_reservation"
      reservation = @reservations_repository.create(build_reservation(input))

      Success(input.merge reservation: reservation)
    end

    def enqueue_reservation(input)
      $logger.info "Reservations::Create::enqueue_reservation"
      @create_reservation_job.perform_later(input)

      Success(input)
    end

    def serialize(input)
      input.fetch(:reservation)
    end
  end
end
