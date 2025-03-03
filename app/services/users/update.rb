module Users
  class Update < Core::Operation

    def initialize(users_repository: UsersRepository.new)
      @users_repository = users_repository
      super()
    end

    step :get_user_by_email
    step :update_user

    private

    def get_user_by_email(input)
      email = input[:email]

      $logger.info "Users::Update::get_user_by_email - email: #{email}"


      user = @users_repository.get_one({email: email}).value_or(nil)
      if user.nil?
        Failure({
          status: :not_found,
          data: "User with email: #{email} not found"
        })
      else
        Success(input.merge user: user)
      end
    end

    def update_user(input)
      $logger.info "Users::Update::update_user - input: #{input}"

      @users_repository.update'User', input
    end
  end
end