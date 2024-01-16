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
end
