module Payments
  class PaymentsRepository < Core::Repository
    def initialize(
      repository: Payment,
      entity: 'payments'
    )
      super
    end
  end
end
