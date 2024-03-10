class Payment < ApplicationRecord
  has_one :user, dependent: :destroy
  has_one :lessor, dependent: :destroy
  has_one :reservation, dependent: :destroy
  has_one :spot, dependent: :destroy

  enum payment_type: {
    ONLINE: "ONLINE",
    CASH: "CASH",
  }
end
