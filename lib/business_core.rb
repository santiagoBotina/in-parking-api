module BusinessCore
  class Operation
    include Dry::Transaction
    include Dry::Monads[:maybe, :result, :try]

    def check_schema_validation(validation)
      if validation.success?
        Success(validation.to_h)
      else
        Failure({
          status: :unprocessable_entity,
          data:  validation.errors
          })
      end
    end

    def fail_with_conflict(entity, error_message = nil)
      $logger.fatal "Operation::fail_with_conflict - Error: #{error_message}"
      Failure({
                status: :conflict,
                data: "Error: #{entity} already exist"
              })
    end

  end

  class Repository
    include Dry::Monads[:maybe, :result, :try]

    HTTP_METHODS = {
      GET: 'GET',
      POST: 'POST',
      PUT: 'PUT',
      DELETE: 'DELETE',
      PATCH: 'PATCH',
    }.freeze

    def fail_with_db_error(entity, error_message = nil, operation)
      $logger.fatal error_message
      Failure({
        status: :internal_server_error,
        data: "Unexpected database error, operation: #{operation}, entity: #{entity}: #{error_message}"
      })
    end

    def fail_with_not_found(entity)
      $logger.fatal "Entity #{entity} not found"
      Failure({
        status: :not_found,
        data: "Entity #{entity} not found"
      })
    end
  end

end