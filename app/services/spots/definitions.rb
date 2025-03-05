module Spots
  class Definitions < ActiveRecord::Base
    module Statuses
      AVAILABLE = 'AVAILABLE'.freeze
      RESERVED = 'RESERVED'.freeze
      UNAVAILABLE = 'UNAVAILABLE'.freeze
    end
  end
end
