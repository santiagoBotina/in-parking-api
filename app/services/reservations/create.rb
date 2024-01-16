module Reservations
  class Create
    include Dry::Transaction

    def initialize(reservations_repository: ReservationsRepository.new)
      @reservations_repository = reservations_repository
      super
    end

    step :check_reservations

    private

    def check_reservations
      $logger.info 'GetReservations::call'

      result = @reservations_repository.get_all.value_or(nil)

      result.nil? ?
        Failure({ status: :internal_server_error, data: 'There was an error processing the request' }) :
        Success({ status: :ok, data: result })
    end

  end
end
