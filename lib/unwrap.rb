module Unwrap

  def unwrap_monad_result(result)
    $logger.info 'ControllerUnwrapUtil::unwrap'

    if result.success?
      render json: result.value!, status: :ok
    else
      render json: result.failure, status: :internal_server_error
    end
  end

end
