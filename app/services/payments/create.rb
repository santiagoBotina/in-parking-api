module Payments
  class Create < BusinessCore::Operation
    def initialize(
      payments_repo: PaymentsRepository.new,
      reservations_repo: Reservations::ReservationsRepository.new,
      update_reservation_job: Reservations::UpdateReservationJob
    )
      @payments_repo = payments_repo
      @reservations_repo = reservations_repo
      @update_reservation_job = update_reservation_job
      super
    end

    step :validate_input
    step :validate_reservation_exists
    step :persist_payment
    tee :update_reservation
    map :return_payment

    def validate_input(input)
      $logger.info "Payments::Create::validate_input - input: #{input}"

      check_schema_validation Contracts::CreatePaymentSchema.call(input)
    end

    def validate_reservation_exists(input)
      $logger.info "Payments::Create::validate_reservation_exists"

      reservation = @reservations_repo
                      .get_one({ id: input.fetch(:reservation_id) })
                      .value_or(nil)

      return Failure({
        status: :not_found,
        data: "Reservation with id: #{input.fetch(:reservation_id)} not found"
      }) if reservation.nil?

      Success(input.merge reservation: reservation)
    end

    def persist_payment(input)
      $logger.info "Payments::Create::persist_payment"
      payment = @payments_repo
                  .create(build_payment(input))
                  .value_or(nil)

      return fail_with_server_error('payment could not be processed') if payment.nil?

      Success(input.merge payment: payment)
    end

    def update_reservation(input)
      $logger.info "Payments::Create::update_reservation"
      @update_reservation_job.perform_later(input)
    end

    def return_payment(input)
      $logger.info "Payments::Create::return_payment"
      {status: :ok, data: input.fetch(:payment)}
    end

    def build_payment(input)
      {
        amount_in_cents: input.fetch(:amount_in_cents),
        status: STATUSES::APPROVED,
        payment_type: input.fetch(:payment_type),
        user_id: input.fetch(:user_id),
        spot_id: input.fetch(:spot_id),
        lessor_id: input.fetch(:lessor_id),
        reservation_id: input.fetch(:reservation_id),
      }
    end
  end
end