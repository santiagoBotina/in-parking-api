module BusinessCore
  class Operation
    include Dry::Transaction
    include Dry::Monads[:maybe, :result, :try]

    def check_schema_validation(validation)
      if validation.success?
        Success(validation.to_h)
      else
        $logger.info "BusinessCore::Operation::check_schema_validation - validation: #{validation.to_h}"

        Failure({
          status: :unprocessable_entity,
          data:  validation.errors
          })
      end
    end

  end

  class Repository
    include Dry::Monads[:maybe, :result, :try]

    def fail_with_db_error(entity, error_message)
      $logger.fatal error_message
      Failure({
        status: :internal_server_error,
        data: "Database error while creating #{entity}: #{error_message}"
      })
    end
  end

end