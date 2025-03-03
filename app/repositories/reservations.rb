module Reservations
  class ReservationsRepository < Core::Repository
    def initialize(
      repository: Reservation,
      entity: 'reservations'
    )
      super
    end

    def get_one_by_id_with_user(id)
      $logger.info "Reservations::ReservationsRepository::" \
        "get_one_by_id_with_user - id: #{id}"

      reservation = @repository
        .includes(:user)
        .find_by(id: id)

      Maybe(reservation)
    end
  end
end
