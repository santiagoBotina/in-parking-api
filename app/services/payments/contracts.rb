module Payments
  PAYMENT_TYPES_ARR = %w'ONLINE OFFLINE'.freeze

  module PAYMENT_TYPES
    ONLINE = 'ONLINE'.freeze
    OFFLINE = 'OFFLINE'.freeze
  end

  module STATUSES
    APPROVED = 'APPROVED'.freeze
    PENDING = 'PENDING'.freeze
    DECLINED = 'DECLINED'.freeze
    REFUNDED = 'REFUNDED'.freeze
  end

  module Contracts
    CreatePaymentSchema = Dry::Schema.Params do
      required(:user_id).filled(:integer)
      required(:reservation_id).filled(:integer)
      required(:spot_id).filled(:integer)
      required(:lessor_id).filled(:integer)
      required(:amount_in_cents).filled(:integer)
      required(:payment_type).filled(:string) { included_in?(PAYMENT_TYPES_ARR) }
    end
  end
end