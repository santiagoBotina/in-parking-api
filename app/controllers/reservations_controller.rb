  class ReservationsController < ApplicationController
    def index
      result = Reservations::GetReservations.new.call
      render json: result, status: :ok
    end
  end
