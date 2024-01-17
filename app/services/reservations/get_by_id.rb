module Reservations
  include BusinessCore
  class GetById < BusinessCore::Operation

    def initialize(reservations_repository: ReservationsRepository.new)
      @reservations_repository = reservations_repository
      super
    end

    step :get_reservation

    private

    def get_reservation(command)
      $logger.info "Reservation::GetByID::get_by_id - id: #{id}"

      reservation = @reservations_repository.get_one(command).value_or(nil)
      if reservation.nil?
        Failure({
          status: :not_found,
          data: "Reservation with ID: #{id} not found"
        })
      else
        Success({ status: :ok, data: reservation })
      end
    end

  end
end