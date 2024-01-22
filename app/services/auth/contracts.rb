module Auth
  include Validators

  module Contracts
    ConfirmSignUpSchema = Dry::Schema.Params do
      required(:email).filled(:string, format?: Validators::EMAIL_REGEX)
      required(:code).filled(:string, min_size?: 6, max_size?: 6)
    end
  end
end