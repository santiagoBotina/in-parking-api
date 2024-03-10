module Users
  class UsersRepository < BusinessCore::Repository
    def initialize(
      repository: User,
      entity: 'users'
    )
      super
    end

  end
end