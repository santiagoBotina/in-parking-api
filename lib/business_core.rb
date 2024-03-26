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

    def fail_with_bad_request(error_message = nil)
      $logger.fatal "Operation::fail_with_bad_request - Error: #{error_message}"
      Failure({
                status: :bad_request,
                data: "Error: #{error_message}"
              })
    end

    def fail_with_unauthorized(error_message = nil)
      $logger.fatal "Operation::fail_with_unauthorized - Error: #{error_message}"
      Failure({
                status: :unauthorized,
                data: "Error: #{error_message}"
              })
    end

    def fail_with_forbidden(error_message = nil)
      $logger.fatal "Operation::fail_with_forbidden - Error: #{error_message}"
      Failure({
                status: :forbidden,
                data: "Error: #{error_message}"
              })
    end

    def fail_with_server_error(error_message = nil)
      $logger.fatal "Operation::fail_with_internal_server_error - Error: #{error_message}"
      Failure({
                status: :internal_server_error,
                data: "Error: #{error_message}"
              })
    end

    def success_with_data(data)
      Success({
        status: :ok,
        data: data
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

    def initialize(repository:, entity:)
      @repository = repository
      @entity = entity
    end

    #TODO: get_all

    def get_one(command)
      begin
        $logger.info "#{self.class}::get_one - command: #{command}"

        result = @repository.find_by(command)
        Maybe(result)
      rescue StandardError => e
        fail_with_db_error(@entity, e.message, HTTP_METHODS[:GET])
      end
    end

    def get_one_with_lock(command)
      begin
        $logger.info "#{self.class}::get_one_with_lock - command: #{command}"

        result = @repository.lock.find_by(command)
        Maybe(result)
      rescue StandardError => e
        fail_with_db_error(@entity, e.message, HTTP_METHODS[:GET])
      end
    end

    def create(input)
      begin
        $logger.info "#{self.class}::create - input: #{input}"

        result = @repository.new(input)

        unless result.save!
          return fail_with_db_error(@entity, 'There was an error processing the request')
        end
        Success({ status: :ok, data: result })
      rescue StandardError => e
        fail_with_db_error(@entity, e.message, HTTP_METHODS[:POST])
      end
    end

    def update(entity, command)
      begin
        $logger.info "#{self.class}::update - entity: #{entity} - command: #{command}"

        entity.update(command)
        Success({ status: :ok, data: entity })
      rescue StandardError => e
        fail_with_db_error(@entity, e.message, HTTP_METHODS[:PUT])
      end
    end

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