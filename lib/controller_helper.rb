module ControllerHelper
  include Dry::Monads[:result]

  def unwrap_monad_result(result)
    $logger.info 'ControllerUnwrapUtil::unwrap'
    $logger.info "ControllerUnwrapUtil::unwrap: #{result}"

    if result.success?
      render json: result.value!, status: result.value![:status]
    else
      render json: result.failure, status: result.failure[:status]
    end
  end

  def parse_request_body(raw_body)
    JSON.parse(raw_body).symbolize_keys
  rescue JSON::ParserError
    Failure('Invalid JSON format')
  end

end
