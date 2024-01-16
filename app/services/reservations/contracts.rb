module Reservations
  RESERVATION_TYPES = %w[ONE_TIME WEEKLY MONTHLY].freeze
  module Contracts

    ReservationSchema = Dry::Schema.Params do
      required(:user_id).filled(:integer)
      required(:spot_id).filled(:integer)
      required(:vehicle_plate).filled(:string)
      required(:reservation_type).filled(:string) { included_in?(RESERVATION_TYPES) }
      required(:reserved_until).filled(:date_time)
    end
  end
end