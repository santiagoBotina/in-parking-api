require 'rails_helper'

RSpec.describe "Auths", type: :request do
  let(:valid_user_params) do
    {
      email: 'test@example.com',
      password: 'password123'
    }
  end

  let(:valid_confirmation_params) do
    {
      email: 'test@example.com',
      confirmation_code: '123456'
    }
  end

  let(:create_service) { instance_double(Auth::Create) }
  let(:login_service) { instance_double(Auth::Login) }
  let(:confirm_sign_up_service) { instance_double(Auth::ConfirmSignUp) }

  before do
    allow(Auth::Create).to receive(:new).and_return(create_service)
    allow(Auth::Login).to receive(:new).and_return(login_service)
    allow(Auth::ConfirmSignUp).to receive(:new).and_return(confirm_sign_up_service)
  end

  describe 'POST /sign_up' do
    before do
      allow(create_service).to receive(:call).and_return(Dry::Monads::Success({status: :created}))
    end

    it 'creates a new user' do
      post '/auth/sign_up', params: valid_user_params.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['status']).to eq('created')
    end
  end

  describe 'POST /login' do
    before do
      allow(login_service).to receive(:call).and_return(Dry::Monads::Success({status: :ok}))
    end

    it 'logs in a user' do
      post '/auth/login', params: valid_user_params.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['status']).to eq('ok')
    end
  end

  describe 'POST /confirm_sign_up' do
    before do
      allow(confirm_sign_up_service).to receive(:call).and_return(Dry::Monads::Success({status: :ok}))
    end

    it 'confirms a user signup' do
      post '/auth/confirm_sign_up', params: valid_confirmation_params.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['status']).to eq('ok')
    end
  end
end
