module Spots
  class SpotsRepository < BusinessCore::Repository
    include Dry::Monads[:maybe, :result]

    def initialize(
      spots_repo: Spot
    )
      @spots = spots_repo
    end

    def get_all
      begin
        $logger.info 'SpotsRepository::all'

        result = @spots.all
        Maybe(result)
      rescue StandardError => e
        fail_with_db_error('spots', e.message, HTTP_METHODS[:GET])
      end
    end

    def create(params)
      begin
        $logger.info "SpotsRepository::create - params: #{params}"

        spot = @spots.new(params)

        unless spot.save!
          return fail_with_db_error('spots', 'There was an error processing the request')
        end
        Success({ status: :ok, data: spot })
      rescue StandardError => e
        fail_with_db_error('spots', e.message, HTTP_METHODS[:POST])
      end
    end

    def get_one(command)
      begin
        $logger.info "SpotsRepository::get_one - command: #{command}"

        result = @spots.find_by(command)
        Maybe(result)
      rescue StandardError => e
        fail_with_db_error('spots', e.message, HTTP_METHODS[:GET])
      end
    end

    def update(input)
      begin
        $logger.info "SpotsRepository::update - command: #{command}"

        spot = @spots.update(input[:command])
        Success({ status: :ok, data: spot })
      rescue StandardError => e
        fail_with_db_error('spots', e.message, HTTP_METHODS[:PUT])
      end
    end
  end
end