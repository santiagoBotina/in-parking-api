module Payments
  class PaymentsRepository < BusinessCore::Repository
    def initialize(
      repository: Payment,
      entity: 'payments'
    )
      super
    end
  end
end