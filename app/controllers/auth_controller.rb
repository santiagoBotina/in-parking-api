class AuthController < ApplicationController
  include ControllerHelper
  include Auth

  def initialize(
    confirm_sign_up: ConfirmSignUp.new
  )
    @confirm_sign_up = confirm_sign_up
  end

  def confirm_sign_up
    $logger.info 'AuthController::confirm_sign_up_path'

    body = parse_request_body(request.body.read)

    result = @confirm_sign_up.call(body)

    unwrap_monad_result(result)
  end

end
