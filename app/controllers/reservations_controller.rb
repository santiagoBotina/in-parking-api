  class ReservationsController < ApplicationController
    include Unwrap
    def index
      $logger.info "ReservationsController::index"

      result = Reservations::GetReservations.new.call

      unwrap_monad_result(result)
    end
  end
