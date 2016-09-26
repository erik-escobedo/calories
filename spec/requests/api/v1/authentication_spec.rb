require 'rails_helper'

describe "Authentication" do
  describe 'Registration' do
    context 'when correct data is provided' do
      let(:params) {
          {
            email: 'erik@codigojade.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
      }

      it 'returns a correct status code' do
        post '/api/v1/auth', params

        expect(response).to be_success
      end

      it 'records a new User into the database' do
        expect { post '/api/v1/auth', params }.to change(User, :count).by(1)
      end
    end

    context 'when incorrect data is provided' do
      let(:params) {
          {
            email: 'erik@codigojade(dot)com',
            password: 'password123',
            password_confirmation: 'password123'
          }
      }

      it 'returns a forbidden status code' do
        post '/api/v1/auth', params

        expect(response.status).to eq(403)
      end

      it 'does not record a new User into the database' do
        expect { post '/api/v1/auth', params }.to_not change(User, :count)
      end
    end
  end

  describe 'Login' do
    let(:user) { create(:user) }

    context 'when correct data is provided' do
      it 'returns a correct status code' do
        post '/api/v1/auth/sign_in', {
          email:    user.email,
          password: 'password'
        }

        expect(response).to be_success
      end
    end

    context 'when incorrect data is provided' do
      it 'returns an unauthorized status code' do
        post '/api/v1/auth/sign_in', {
          email:    user.email,
          password: 'WRONG_PASSWORD'
        }

        expect(response.status).to eq(401)
      end
    end
  end
end
