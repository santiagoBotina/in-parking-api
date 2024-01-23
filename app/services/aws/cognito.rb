require_relative 'definitions.rb'

module Aws
  class Cognito
    @client = Aws::CognitoIdentityProvider::Client.new(
      region: REGION,
      credentials: Aws::Credentials.new(
        ACCESS_KEY_ID,
        SECRET_ACCESS_KEY
      )
    )

    def self.authenticate(user_object)
      $logger.info "Aws::Cognito - authenticate - user_object: #{user_object}"

      auth_object = {
        client_id: CLIENT_ID,
        auth_flow: AUTH_FLOW,
        auth_parameters: user_object
      }

      @client.initiate_auth(auth_object).authentication_result
    end

    def self.sign_out(access_token)
      @client.global_sign_out(access_token: access_token)
    end

    def self.create_user(input)
      $logger.info "Aws::Cognito - create_user - input: #{input}"

      auth_object = {
        client_id: CLIENT_ID,
        username: input[:email],
        password: input[:password],
        user_attributes: build_user_attributes(input)
      }

      @client.sign_up(auth_object).to_h
    end

    def self.confirm_sign_up(input)
      $logger.info "Aws::Cognito - confirm_sign_up - input: #{input}"

      sign_up_info = {
        client_id: CLIENT_ID,
        username: input[:email],
        confirmation_code: input[:code],
      }

      @client.confirm_sign_up(sign_up_info)
    end

    private

    def self.calculate_secret_hash(username)
      data = "#{username}#{CLIENT_ID}"
      Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', CLIENT_SECRET, data))
    end

    def self.build_user_attributes(input)
      [
        {
          name: 'given_name',
          value: input[:first_name]
        },
        {
          name: 'family_name',
          value: input[:last_name]
        },
        {
          name: 'phone_number',
          value: input[:phone]
        }
      ]
    end

  end
end