module Reservations
  include BusinessCore
  class Create < BusinessCore::Operation

    def initialize(reservations_repository: ReservationsRepository.new)
      @reservations_repository = reservations_repository
      super
    end

    step :validate_input
    step :create

    private

    def validate_input(input)
      $logger.info "Reservations::Create::validate_input - input: #{input}"

      check_schema_validation Contracts::ReservationSchema.call(input)
    end

    def create(input)
      $logger.info 'Reservations::Create::create'
      begin
        @reservations_repository.create(input)
      rescue StandardError => e
        $logger.info "Reservations::Create::create - error: #{e}"
      end
    end

  end
end
