module Auth
  include Validators
  module Contracts
    USER_LEGAL_ID_TYPES = %w[CC NIT PP CE TI].freeze

    SignUpSchema = Dry::Schema.Params do
      required(:first_name).filled(:string)
      required(:last_name).filled(:string)
      required(:legal_id_type).filled(:string) { included_in?(USER_LEGAL_ID_TYPES) }
      required(:legal_id).filled(:string)
      required(:email).filled(:string, format?: Validators::EMAIL_REGEX)
      required(:phone).filled(:string)
      required(:password).filled(:string)
    end

    ConfirmSignUpSchema = Dry::Schema.Params do
      required(:email).filled(:string, format?: Validators::EMAIL_REGEX)
      required(:code).filled(:string, min_size?: 6, max_size?: 6)
    end

    LoginSchema = Dry::Schema.Params do
      required(:email).filled(:string, format?: Validators::EMAIL_REGEX)
      required(:password).filled(:string)
    end
  end
end