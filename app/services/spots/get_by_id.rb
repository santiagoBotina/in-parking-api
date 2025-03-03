module Spots
  class GetById < Core::Operation
    def initialize(
      spots_repository: SpotsRepository.new
    )
      @spots_repository = spots_repository
      super()
    end

    step :get_spot

    private

    def get_spot(command)
      $logger.info "Spot::GetByID::get_one - command: #{command}"

      spot = @spots_repository.get_one(command).value_or(nil)
      if spot.nil?
        error_message = ''

        command.each do |key, value|
          error_message = "Spot with #{key}: #{value} not found"
        end

        Failure({
          status: :not_found,
          data: error_message
        })
      else
        Success({ status: :ok, data: spot })
      end
    end

  end
end