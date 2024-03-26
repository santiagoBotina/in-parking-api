class PaymentsController < ApplicationController
  include ControllerHelper
  include Payments

  def initialize(
    create: Create.new
  )
    @create = create
  end

  def create
    $logger.info 'PaymentsController::create'

    body = parse_request_body(request.body.read)

    unwrap_monad_result(@create.call(body))
  end
end
