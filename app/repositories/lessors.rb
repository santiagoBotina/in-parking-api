module Lessors
  class LessorsRepository < BusinessCore::Repository
    def initialize(
      lessors_repo: Lessor
    )
      @lessors = lessors_repo
    end

    def get_one(command)
      begin
        $logger.info "LessorsRepository::get_one - command: #{command}"

        result = @lessors.find_by(command)
        Maybe(result)
      rescue StandardError => e
        fail_with_db_error('lessors', e.message, HTTP_METHODS[:GET])
      end
    end

    def create(params)
      begin
        $logger.info "LessorsRepository::create - params: #{params}"

        merchant = @lessors.new(params)

        unless merchant.save!
          return fail_with_db_error('lessors', 'There was an error processing the request')
        end
        Success({ status: :ok, data: merchant })
      rescue StandardError => e
        fail_with_db_error('lessors', e.message, HTTP_METHODS[:POST])
      end
    end

    def update(input)
      begin
        $logger.info "LessorsRepository::update - email: #{input[:email]} - input: #{input}"

        merchant = input[:user]

        merchant.update(input[:command])
        Success({ status: :ok, data: merchant })
      rescue StandardError => e
        fail_with_db_error('lessor', e.message, HTTP_METHODS[:PUT])
      end
    end

  end
end