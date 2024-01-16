class Reservation < ApplicationRecord
  enum reservation_type: {
    one_time: "ONE_TIME",
    weekly: "WEEKLY",
    monthly: "MONTHLY"
  }
end
