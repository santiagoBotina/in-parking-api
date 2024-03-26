class UpdateReservationJob < ApplicationJob
  queue_as :default

  queue_as :default

  def perform(input)
    $logger.info "Reservations::UpdateReservationJob::perform - input: #{input}"

    UpdateAfterPayment.new.call(input)
  end
end
