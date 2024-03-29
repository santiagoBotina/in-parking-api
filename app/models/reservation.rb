class Reservation < ApplicationRecord
  has_one :user, dependent: :destroy

  enum reservation_type: {
    ONE_TIME: "ONE_TIME",
    WEEKLY: "WEEKLY",
    MONTHLY: "MONTHLY"
  }

end
