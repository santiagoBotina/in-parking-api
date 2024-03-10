module Reservations
  class ReservationsRepository < BusinessCore::Repository
    def initialize(
      repository: Reservation,
      entity: 'reservations'
    )
      super
    end

  end
end