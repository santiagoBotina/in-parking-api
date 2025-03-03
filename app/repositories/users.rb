module Users
  class UsersRepository < Core::Repository
    def initialize(
      repository: User,
      entity: 'users'
    )
      super
    end
  end
end
