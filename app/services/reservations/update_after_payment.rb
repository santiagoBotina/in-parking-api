module Reservations
  class UpdateAfterPayment < BusinessCore::Operation
    def initialize
      super
    end

    step :validate_online_payment_status
    step :reserve_spot_and_update_reservation

    private

    def validate_online_payment_status(input)
      $logger.info "Reservation::UpdateAfterPayment::validate_online_payment_status - input: #{input}"

      status = input.fetch(:payment).status
      payment_type = input.fetch(:payment).payment_type

      if payment_type == 'ONLINE' && status != 'APPROVED'
        return Failure({
          status: :bad_request,
          data: 'Status must be of APPROVED for ONLINE payments'
        })
      end

      Success(input)
    end

    def reserve_spot_and_update_reservation(input)
      $logger.info 'Reservation::UpdateAfterPayment::reserve_spot'

      ActiveRecord::Base.transaction do
        spot = Spot.find_by({ id: input[:spot_id] })
        reservation = input[:reservation]
        raise ActiveRecord::Rollback if spot.nil? || spot.status != 'AVAILABLE'

        spot.update!(status: 'RESERVED')
        reservation.update!(status: 'ACTIVE')
      end

      Success(input)
    end
  end
end