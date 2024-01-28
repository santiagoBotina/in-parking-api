class MerchantsController < ApplicationController
  include ControllerHelper
  include Merchants

  def initialize(
    create: Create.new
  )
    @create = create
  end

  def create
    $logger.info 'MerchantsController::create'

    body = parse_request_body(request.body.read)

    unwrap_monad_result(@create.call(body))
  end
end
