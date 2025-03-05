require_relative 'definitions.rb'

module Aws
  class Cognito

    @client ||= Aws::CognitoIdentityProvider::Client.new(
      region: REGION,
      credentials: Aws::Credentials.new(
        ACCESS_KEY_ID,
        SECRET_ACCESS_KEY
      )
    )

    def self.authenticate(user_object, role)
      $logger.info "Aws::Cognito - authenticate - user_object: #{user_object}"

      auth_object = {
        client_id: get_client_id(role),
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

      user_attributes = input[:role] === 'LESSOR' ?
        build_lessor_attributes(input) :
        build_user_attributes(input)

      auth_object = {
        client_id: get_client_id(input[:role]),
        username: input[:email],
        password: input[:password],
        user_attributes: user_attributes
      }

      @client.sign_up(auth_object).to_h
    rescue Aws::CognitoIdentityProvider::Errors::UsernameExistsException
      $logger.error "Aws::Cognito::create_user::ERROR - USERNAME ALREADY EXISTS"

      {error: true, status: :bad_request, data: 'Username already exists'}
    rescue StandardError => e
      $logger.error "Aws::Cognito::create_user::ERROR - unknown #{e}"

      {error: true, status: :internal_server_error, data: 'Something went wrong creating the user'}
    end

    def self.confirm_sign_up(input)
      $logger.info "Aws::Cognito - confirm_sign_up - input: #{input}"

      sign_up_info = {
        client_id: get_client_id(input[:role]),
        username: input[:email],
        confirmation_code: input[:code],
      }

      @client.confirm_sign_up(sign_up_info).to_h
    rescue Aws::CognitoIdentityProvider::Errors::CodeMismatchException
      $logger.error "Auth::ConfirmSignUp::confirm_sign_up::ERROR - CODE MISMATCH"

      {error: true, status: :bad_request, data: 'Code mismatch'}
    rescue Aws::CognitoIdentityProvider::Errors::ExpiredCodeException
      $logger.error "Auth::ConfirmSignUp::confirm_sign_up::ERROR - EXPIRED CODE"

      {error: true, status: :forbidden, data: 'Code is expired or is invalid'}
    rescue StandardError => e
      $logger.error "Auth::ConfirmSignUp::confirm_sign_up::ERROR - unknown #{e}"

      {error: true, status: :internal_server_error, data: 'Something went wrong confirming the user'}
    end

    private

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

    def self.build_lessor_attributes(input)
      [
        {
          name: 'custom:legal_name',
          value: input[:legal_name]
        },
        {
          name: 'custom:lessor_name',
          value: input[:lessor_name]
        },
        {
          name: 'custom:legal_id_type',
          value: input[:legal_id_type]
        },
        {
          name: 'custom:legal_id',
          value: input[:legal_id]
        },
        {
          name: 'phone_number',
          value: input[:phone]
        },
        {
          name: 'address',
          value: input[:address]
        },
        {
          name: 'custom:city',
          value: input[:city]
        },
      ]
    end

    def self.get_client_id(role)
      role === 'LESSOR' ? LESSOR_CLIENT_ID : CONSUMER_CLIENT_ID
    end
  end
end