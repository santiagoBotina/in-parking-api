class Reservation < ApplicationRecord
  enum reservation_type: {
    ONE_TIME: "ONE_TIME",
    WEEKLY: "WEEKLY",
    MONTHLY: "MONTHLY"
  }

end
