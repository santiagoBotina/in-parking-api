module Auth
  include Validators
  module Contracts
    USER_LEGAL_ID_TYPES = %w[CC NIT PP CE TI].freeze
    ROLES = %w[MERCHANT CONSUMER].freeze

    ConfirmSignUpSchema = Dry::Schema.Params do
      required(:email).filled(:string, format?: Validators::EMAIL_REGEX)
      required(:code).filled(:string, min_size?: 6, max_size?: 6)
      required(:role).filled(:string, included_in?: ROLES)
    end

    LoginSchema = Dry::Schema.Params do
      required(:email).filled(:string, format?: Validators::EMAIL_REGEX)
      required(:password).filled(:string)
      required(:role).filled(:string, included_in?: ROLES)
    end
  end
end