class Reservation < ApplicationRecord
  belongs_to :user

  enum reservation_type: {
    ONE_TIME: "ONE_TIME",
    WEEKLY: "WEEKLY",
    MONTHLY: "MONTHLY"
  }

end
