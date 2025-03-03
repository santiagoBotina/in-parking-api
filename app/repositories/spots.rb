module Spots
  class SpotsRepository < Core::Repository
    def initialize(
      repository: Spot,
      entity: 'spots'
    )
      super
    end
  end
end
