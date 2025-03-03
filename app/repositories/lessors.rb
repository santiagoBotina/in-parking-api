module Lessors
  class LessorsRepository < Core::Repository
    def initialize(
      repository: Lessor,
      entity: 'lessors'
    )
      super
    end
  end
end
