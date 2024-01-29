class LessorsController < ApplicationController
  include ControllerHelper
  include Lessors

  def initialize(
    create: Create.new
  )
    @create = create
  end

  def create
    $logger.info 'LessorsController::create'

    body = parse_request_body(request.body.read)

    unwrap_monad_result(@create.call(body))
  end
end
