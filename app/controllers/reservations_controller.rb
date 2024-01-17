class ReservationsController < ApplicationController
  include ControllerHelper
  include Reservations
  def index
    $logger.info 'ReservationsController::index'

    unwrap_monad_result(GetAll.new.call)
  end

  def create
    $logger.info 'ReservationsController::create'

    body = parse_request_body(request.body.read)

    result = Create.new.call(body)
    $logger.info "ReservationsController::create - result: #{result}"
    unwrap_monad_result(result)
  end

  def show
    $logger.info "ReservationsController::show - reservation_id: #{params[:id]}"

    get_by_reservation_id_command = { id: params[:id] }

    unwrap_monad_result(GetById.new.call(get_by_reservation_id_command))
  end
end
