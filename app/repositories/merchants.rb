module Merchants
  class MerchantsRepository < BusinessCore::Repository
    def initialize(
      merchants_repo: Merchant
    )
      @merchants = merchants_repo
    end

    def get_one(command)
      begin
        $logger.info "MerchantsRepository::get_one - command: #{command}"

        result = @merchants.find_by(command)
        Maybe(result)
      rescue StandardError => e
        fail_with_db_error('merchants', e.message, HTTP_METHODS[:GET])
      end
    end

    def create(params)
      begin
        $logger.info "MerchantsRepository::create - params: #{params}"

        merchant = @merchants.new(params)

        unless merchant.save!
          return fail_with_db_error('merchants', 'There was an error processing the request')
        end
        Success({ status: :ok, data: merchant })
      rescue StandardError => e
        fail_with_db_error('merchants', e.message, HTTP_METHODS[:POST])
      end
    end

    def update(input)
      begin
        $logger.info "MerchantsRepository::update - email: #{input[:email]} - input: #{input}"

        merchant = input[:user]

        merchant.update(input[:command])
        Success({ status: :ok, data: merchant })
      rescue StandardError => e
        fail_with_db_error('merchant', e.message, HTTP_METHODS[:PUT])
      end
    end

  end
end