module Reservations
  RESERVATION_TYPES = %w[ONE_TIME WEEKLY MONTHLY].freeze
  RESERVATION_STATUSES = %w[ACTIVE CANCELLED MISSED].freeze

  module Contracts
    ReservationSchema = Dry::Schema.Params do
      required(:user_id).filled(:integer)
      required(:spot_id).filled(:integer)
      required(:lessor_id).filled(:integer)
      required(:vehicle_plate).filled(:string)
      required(:reservation_type).filled(:string) { included_in?(RESERVATION_TYPES) }
      required(:check_in).filled(:date_time)
      required(:check_out).filled(:date_time)
    end
  end
end