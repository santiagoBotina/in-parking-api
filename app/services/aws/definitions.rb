module AwsService
    REGION = ENV['AWS_REGION']

    CONSUMER_POOL_ID = ENV['AWS_COGNITO_CONSUMERS_POOL_ID']
    CONSUMER_CLIENT_ID = ENV['AWS_COGNITO_CONSUMERS_CLIENT_ID']

    LESSOR_POOL_ID = ENV['AWS_COGNITO_LESSORS_POOL_ID']
    LESSOR_CLIENT_ID = ENV['AWS_COGNITO_LESSORS_CLIENT_ID']

    AUTH_FLOW = ENV['AWS_COGNITO_USERS_AUTH_FLOW']
    ACCESS_KEY_ID = ENV['AWS_ACCESS_KEY_ID']
    SECRET_ACCESS_KEY = ENV['AWS_SECRET_ACCESS_KEY']
end
