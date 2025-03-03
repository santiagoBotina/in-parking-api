module Users
  class GetById < Core::Operation
    def initialize(users_repository: UsersRepository.new)
      @users_repository = users_repository
      super()
    end

    step :get_user

    private

    def get_user(command)
      $logger.info "Users::GetByID::get_user - command: #{command}"

      user = @users_repository.get_one(command).value_or(nil)
      if user.nil?
        error_message = ''

        command.each do |key, value|
          error_message = "User with #{key}: #{value} not found"
        end

        Failure({
          status: :not_found,
          data: error_message
        })
      else
        Success({ status: :ok, data: user })
      end
    end
  end
end