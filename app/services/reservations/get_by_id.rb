module Reservations
  include BusinessCore
  class GetById < BusinessCore::Operation

    def initialize(
      reservations_repository: ReservationsRepository.new
    )
      @reservations_repository = reservations_repository
      super
    end

    step :get_reservation

    private

    def get_reservation(command)
      $logger.info "Reservation::GetByID::get_one - command: #{command}"

      reservation = @reservations_repository.get_one(command).value_or(nil)
      if reservation.nil?
        error_message = ''

        command.each do |key, value|
          error_message = "Reservation with #{key}: #{value} not found"
        end

        Failure({
          status: :not_found,
          data: error_message
        })
      else
        Success({ status: :ok, data: reservation })
      end
    end

  end
end