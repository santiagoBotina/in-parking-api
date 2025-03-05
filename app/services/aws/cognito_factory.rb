module Aws
  class CognitoFactory
    def self.get_cognito
      $logger.info "Aws::CognitoFactory::APP_ENV #{ENV['APP_ENV']}"

      ENV['APP_ENV'] == 'local' ? CognitoMock: Cognito
    end
  end
end
