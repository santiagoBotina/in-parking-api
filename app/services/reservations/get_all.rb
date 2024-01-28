module Reservations
  class GetAll < BusinessCore::Operation
    def initialize(reservations_repository: ReservationsRepository.new)
      @reservations_repository = reservations_repository
      super
    end

    step :check_reservations

    private

    def check_reservations
      $logger.info 'Reservations::GetAll::call'

      result = @reservations_repository.get_all.value_or(nil)

      result.nil? ?
        Failure({ status: :internal_server_error, data: 'There was an error processing the request' }) :
        Success({ status: :ok, data: result })
    end

  end
end
