module Lessors
  class LessorsRepository < BusinessCore::Repository
    def initialize(
      repository: Lessor,
      entity: 'lessors'
    )
      super
    end

  end
end