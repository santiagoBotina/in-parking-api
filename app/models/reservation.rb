class Reservation < ApplicationRecord
  enum reservation_type: [:ONE_TIME, :WEEKLY, :MONTHLY]
end
