module Users
  include BusinessCore
  class UsersRepository < Repository
    include Dry::Monads[:maybe, :result]

    def initialize(
      users_repo: User
    )
      @users = users_repo
    end

    def get_one(command)
      begin
        $logger.info "UsersRepository::get_one - command: #{command}"

        result = @users.find_by(command)
        Maybe(result)
      rescue StandardError => e
        fail_with_db_error('users', e.message, HTTP_METHODS[:GET])
      end
    end

    def create(input)
      begin
        $logger.info "UsersRepository::create - input: #{input}"

        result = @users.new(input)

        unless result.save!
          return fail_with_db_error('users', 'There was an error processing the request')
        end
        Success({ status: :ok, data: result })
      rescue StandardError => e
        fail_with_db_error('users', e.message, HTTP_METHODS[:POST])
      end
    end

    def update(input)
      begin
        $logger.info "UsersRepository::update - email: #{input[:email]} - input: #{input}"

        user = input[:user]

        user.update(input[:command])
        Success({ status: :ok, data: user })
      rescue StandardError => e
        fail_with_db_error('users', e.message, HTTP_METHODS[:PUT])
      end
    end

  end
end