module Merchants


  LEGAL_ID_TYPES = %w[CC NIT PP CE RUC].freeze
  BANK_ACCOUNT_TYPES = %w[SAVINGS CHECKING].freeze

  module Contracts
    include Auth

    CreateMerchantContract = Dry::Schema.Params do
      required(:legal_name).filled(:string)
      required(:legal_id_type).filled(:string) { included_in?(Merchants::LEGAL_ID_TYPES) }
      required(:legal_id).filled(:string)
      required(:contact_name).filled(:string)
      required(:phone).filled(:string)
      required(:email).filled(:string)
      required(:password).filled(:string)
      required(:city).filled(:string)
      required(:address).filled(:string)
      required(:description).filled(:string)
      required(:logo).filled(:string)
      required(:bank_account_type).filled(:string) { included_in?(Merchants::BANK_ACCOUNT_TYPES ) }
      required(:bank_account_number).filled(:string)
      required(:role).filled(:string) { included_in?(Auth::Contracts::ROLES)}
    end
  end
end