class Reservation < ApplicationRecord
  enum reservation_type: {
    ONE_TIME: "ONE_TIME",
    WEEKLY: "WEEKLY",
    MONTHLY: "MONTHLY"
  }

  enum reservation_status: {
    ACTIVE: "ACTIVE",
    CANCELLED: "CANCELLED",
    MISSED: "MISSED"
  }
end
