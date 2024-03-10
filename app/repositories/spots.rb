module Spots
  class SpotsRepository < BusinessCore::Repository
    def initialize(
      repository: Spot,
      entity: 'spots'
    )
      super
    end

  end
end