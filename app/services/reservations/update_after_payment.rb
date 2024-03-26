module Reservations
  class UpdateAfterPayment < BusinessCore::Operation
    def initialize(
      reservations_repository: ReservationsRepository.new,
      payments_repository: Payments::PaymentsRepository.new
    )
      @reservations_repository = reservations_repository
      @payments_repository = payments_repository
      super
    end

    step :get_reservation
    step :validate_online_payment_status
    step :update_reservation

    private

    def get_reservation(input)
      $logger.info 'Reservation::UpdateAfterPayment::get_reservation'

      reservation = @reservations_repository
                      .get_one({id: input.fetch(:reservation_id)})
                      .value!

      Success(input.merge reservation: reservation)
    end

    def validate_online_payment_status(input)
      status = input.fetch(:payment).fetch(:status)
      payment_type = input.fetch(:payment).fetch(:payment_type)

      unless status != 'APPROVED' && payment_type == 'ONLINE'
        return Failure({
          status: :bad_request,
          data: 'Status must be of APPROVED for ONLINE payments'
        })
      end

      Success(input)
    end

    def update_reservation(input)
      $logger.info 'Reservation::UpdateAfterPayment::update_reservation'

      reservation = input.fetch(:reservation)
      reservation.update!(status: 'ACTIVE')

      Success(input)
    end
  end
end