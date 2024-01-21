module Users
  include Validators
  USER_LEGAL_ID_TYPES = %w[CC NIT PP CE TI].freeze

  module UserLegalIdTypes
    CC = "CC".freeze # Colombian's citizen identification
    NIT = "NIT".freeze # Colombian's company identification number
    PP = "PP".freeze # Passport
    CE = "CE".freeze # Foreigner's ID in Colombia
    TI = "TI".freeze # Children's ID in Colombia
  end

  module Contracts
    CreateUserSchema = Dry::Schema.Params do
      required(:first_name).filled(:string)
      required(:last_name).filled(:string)
      required(:legal_id_type).filled(:string) { included_in?(USER_LEGAL_ID_TYPES) }
      required(:legal_id).filled(:string)
      required(:email).filled(:string, format?: Validators::EMAIL_REGEX)
      required(:phone).filled(:string)
      required(:password).filled(:string)
    end
  end
end