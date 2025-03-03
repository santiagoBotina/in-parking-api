class AuthController < ApplicationController
  include ControllerHelper
  include Auth

  def initialize(
    confirm_sign_up: ConfirmSignUp.new,
    login: Login.new,
    create: Create.new
  )
    @confirm_sign_up = confirm_sign_up
    @login = login
    @create = create
  end

  def sign_up
    $logger.info 'AuthController::sign_up'

    body = parse_request_body(request.body.read)

    unwrap_monad_result(@create.call(body))
  end

  def login
    $logger.info 'AuthController::login'

    body = parse_request_body(request.body.read)

    unwrap_monad_result(@login.call(body))
  end

  def confirm_sign_up
    $logger.info 'AuthController::confirm_sign_up'

    body = parse_request_body(request.body.read)

    unwrap_monad_result(@confirm_sign_up.call(body))
  end
end
