module Reservations
  include BusinessCore
  class ReservationsRepository < Repository
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
        fail_with_db_error('reservations', e.message)
      end
    end

    def create(params)
      begin
        $logger.info "ReservationsRepository::create - params: #{params}"

        reservation = @reservations.new(params)

        unless reservation.save!
          return fail_with_db_error('reservations', 'There was an error processing the request')
        end
        Success({ status: :ok, data: reservation })
      rescue StandardError => e
        fail_with_db_error('reservations', e.message)
      end
    end

    def get_by_id(id)
      begin
        $logger.info "ReservationsRepository::get_by_id - id: #{id}"

        result = @reservations.find_by(id: id)
        Maybe(result)
      rescue StandardError => e
        fail_with_db_error('reservations', e.message)
      end
    end

  end
end