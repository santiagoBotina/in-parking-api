module AWS
    class Definitions < ActiveRecord::Base
        REGION = ENV['AWS_REGION'].freeze

        CONSUMER_POOL_ID = ENV['AWS_COGNITO_CONSUMERS_POOL_ID'].freeze
        CONSUMER_CLIENT_ID = ENV['AWS_COGNITO_CONSUMERS_CLIENT_ID'].freeze

        LESSOR_POOL_ID = ENV['AWS_COGNITO_LESSORS_POOL_ID'].freeze
        LESSOR_CLIENT_ID = ENV['AWS_COGNITO_LESSORS_CLIENT_ID'].freeze

        AUTH_FLOW = ENV['AWS_COGNITO_USERS_AUTH_FLOW'].freeze
        ACCESS_KEY_ID = ENV['AWS_ACCESS_KEY_ID'].freeze
        SECRET_ACCESS_KEY = ENV['AWS_SECRET_ACCESS_KEY'].freeze
    end
end
