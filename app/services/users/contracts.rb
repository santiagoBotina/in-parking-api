module Users
  include Validators

  module UserLegalIdTypes
    CC = "CC".freeze # Colombian's citizen identification
    NIT = "NIT".freeze # Colombian's company identification number
    PP = "PP".freeze # Passport
    CE = "CE".freeze # Foreigner's ID in Colombia
    TI = "TI".freeze # Children's ID in Colombia
  end

  module Contracts
  end
end