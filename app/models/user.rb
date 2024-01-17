class User < ApplicationRecord
  has_many :reservations, dependent: :destroy

  enum legal_id_type: {
    CC: 'CC',
    NIT: 'NIT',
    PP: 'PP',
    CE: 'CE',
    TI: 'TI'
  }

  enum status_type: {
    ACTIVE: "ACTIVE",
    INACTIVE: "INACTIVE",
  }
end
