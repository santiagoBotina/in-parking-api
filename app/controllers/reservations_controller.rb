class ReservationsController < ApplicationController
  include ControllerHelper
  include Reservations

  def initialize(
    get_all: GetAll.new,
    create: Create.new,
    get_by_id: GetById.new
  )
    @get_all = get_all
    @create = create
    @get_by_id = get_by_id
  end
  def index
    $logger.info 'ReservationsController::index'

    unwrap_monad_result(@get_all.call)
  end

  def create
    $logger.info 'ReservationsController::create'

    body = parse_request_body(request.body.read)

    result = @create.call(body)
    $logger.info "ReservationsController::create - result: #{result}"

    unwrap_monad_result(result)
  end

  def show
    $logger.info "ReservationsController::show - reservation_id: #{params[:id]}"

    get_by_reservation_id_command = { id: params[:id] }

    unwrap_monad_result(@get_by_id.call(get_by_reservation_id_command))
  end
end
