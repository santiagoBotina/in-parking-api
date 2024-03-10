module Payments
  class PaymentsRepository < BusinessCore::Repository
    include Dry::Monads[:maybe, :result]

    def initialize(
      payments_repo: Payment
    )
      @payments = payments_repo
    end

    def get_all
      begin
        $logger.info 'PaymentsRepository::all'

        result = @payments.all
        Maybe(result)
      rescue StandardError => e
        fail_with_db_error('payments', e.message, HTTP_METHODS[:GET])
      end
    end

    def create(params)
      begin
        $logger.info "PaymentsRepository::create - params: #{params}"

        payment = @payments.new(params)

        unless payment.save!
          return fail_with_db_error('payments', 'There was an error processing the request')
        end
        Success({ status: :ok, data: payment })
      rescue StandardError => e
        fail_with_db_error('payments', e.message, HTTP_METHODS[:POST])
      end
    end

    def get_one(command)
      begin
        $logger.info "PaymentsRepository::get_one - command: #{command}"

        result = @payments.find_by(command)
        Maybe(result)
      rescue StandardError => e
        fail_with_db_error('payments', e.message, HTTP_METHODS[:GET])
      end
    end

    def update(input)
      begin
        $logger.info "PaymentsRepository::update - command: #{command}"

        payment = @payments.update(input[:command])
        Success({ status: :ok, data: payment })
      rescue StandardError => e
        fail_with_db_error('payments', e.message, HTTP_METHODS[:PUT])
      end
    end
  end
end