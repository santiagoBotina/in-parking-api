module AwsService
  class CognitoMock
    def self.authenticate(user_object, _role)
      $logger.info "Aws::CognitoMock - authenticate - user_object: #{user_object}"

      {
        challenge_name: "IN_PARKING_AUTH_MOCK",
        challenge_parameters: {
          "FRIENDLY_DEVICE_NAME" => 'testuser',
          "USER_ID_FOR_SRP" => 'testuser',
        },
        session: "AYABeC1-wGP3HuBF5Izvxf--A3dZzfYDC0IODsrcMkrbeeVyMJk-"\
          "FCzsxS9Og8BEBVnvi9WjZkPJ4mF0YS6FUXnoPSBV5oUqGzRaT-"\
          "tJ169SUFZAUfFM1fGeJ8T57-QdCxjyISRCWV1VG5_7TiCioyRGfWwzNVWh7ex"\
          "JortF3ccfOyiEyxeqJ2VJvJq3m_w8NP24_PMDpktpRMKftObIMlD5ewRTNCdrUX",
      }
    end

    def self.create_user(input)
      $logger.info "Aws::CognitoMock - create_user - input: #{input}"

      { user_sub: rand(10**9..10**10 - 1) }
    end

    def self.confirm_sign_up(input)
      $logger.info "Aws::CognitoMock - confirm_sign_up - input: #{input}"

      { success: true }
    end
  end
end
