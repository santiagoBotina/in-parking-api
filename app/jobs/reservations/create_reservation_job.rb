module Reservations
  class CreateReservationJob < ApplicationJob
    queue_as :default

    def perform(input)
      $logger.info "Reservations::CreateReservationJob::perform - input: #{input}"

      ActiveRecord::Base.transaction do
        spot = input[:spot]
        raise ActiveRecord::Rollback if spot.nil? || spot.status != 'AVAILABLE'

        payment = Payment.

        spot.update!(status: 'RESERVED')
        reservation = Reservation.find_by({id: input[:reservation][:id]})

        reservation.update!(status: 'ACTIVE')
      end
    rescue ActiveRecord::RecordInvalid
      $logger.info "Reservations::Create::reserve_spot_and_create_reservation - transaction error!"
    end

    def build_reservation(input)
      $logger.info "Reservations::Create::build_reservation"

      {
        user_id: input[:user_id],
        spot_id: input[:spot_id],
        lessor_id: input[:lessor_id],
        check_in: input[:check_in],
        check_out: input[:check_out],
        reservation_type: input[:reservation_type],
        vehicle_plate: input[:vehicle_plate],
      }
    end
  end
end
