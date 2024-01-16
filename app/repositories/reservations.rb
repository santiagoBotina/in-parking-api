module Reservations
  class ReservationsRepository
    include Dry::Monads[:maybe, :result]

    def initialize(
      reservations_repo: Reservation
    )
      @reservations = reservations_repo
    end

    def get_all
      begin
        $logger.info 'ReservationsRepository::all'

        result = @reservations.all
        Maybe(result)
      rescue StandardError => e
        Failure("Database error: #{e.message}")
      end
    end

  end
end