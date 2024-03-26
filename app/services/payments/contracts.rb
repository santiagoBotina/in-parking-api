module Payments
  STATUSES = %w'APPROVED PENDING DECLINED REFUNDED'.freeze
  PAYMENT_TYPES = %w'ONLINE CASH'.freeze

  module Contracts
    CreatePaymentSchema = Dry::Schema.Params do
      required(:user_id).filled(:integer)
      required(:reservation_id).filled(:integer)
      required(:spot_id).filled(:integer)
      required(:lessor_id).filled(:integer)
      required(:amount_in_cents).filled(:integer)
      required(:status).filled(:string) { included_in?(STATUSES) }
      required(:payment_type).filled(:string) { included_in?(PAYMENT_TYPES) }
      required(:check_in).filled(:date_time)
      required(:check_out).filled(:date_time)
    end
  end
end