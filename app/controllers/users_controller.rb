class UsersController < ApplicationController
  include ControllerHelper
  include Users

  def initialize(
    get_by_id: GetById.new
  )
    @get_by_id = get_by_id
  end

  def show
    $logger.info "UsersController::show - user_id: #{params[:id]}"

    get_by_user_id_command = { id: params[:id] }

    unwrap_monad_result(@get_by_id.call(get_by_user_id_command))
  end
end
