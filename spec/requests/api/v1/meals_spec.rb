require 'rails_helper'

describe "Meals API" do
  let(:user) { create(:user) }

  def login
    post '/api/v1/auth/sign_in', {
      email:     user.email,
      password: 'password'
    }

    @headers = {
      'access-token' => response.headers['access-token'],
      'token-type'   => 'Bearer',
      'client'       => response.headers['client'],
      'uid'          => user.email
    }
  end

  describe 'create' do
    let(:meal_params) { attributes_for(:meal) }

    context 'when user is authenticated' do
      before(:each) { login }

      context 'when correct data is provided' do
        it 'returns a correct status code' do
          post '/api/v1/meals', { meal: meal_params }, @headers

          expect(response).to be_success
        end

        it 'creates a new Meal in the database' do
          expect {
            post '/api/v1/meals', { meal: meal_params }, @headers
          }.to change(user.meals, :count).by(1)
        end
      end

      context 'when wrong data is provided' do
        it 'returns an Unprocessable Entity status code' do
          meal_params[:calories] = -50

          post '/api/v1/meals', { meal: meal_params }, @headers

          expect(response.status).to eq(422)
        end

        it 'does not create a new Meal' do
          meal_params[:calories] = -50

          expect {
            post '/api/v1/meals', { meal: meal_params }, @headers
          }.to_not change(Meal, :count)
        end
      end
    end

    context 'when User is not authenticated' do
      it 'returns Unauthorized status' do
        post '/api/v1/meals', { meal: meal_params }

        expect(response.status).to eq(401)
      end
    end
  end

  describe 'update' do
    let(:my_meal) { create(:meal, user_id: user.id, description: 'Original description') }
    let(:meal_params) { attributes_for(:meal, description: 'Modified description') }

    context 'when user is authenticated' do
      before(:each) { login }

      context 'when user owns the meal' do
        context 'when correct data is provided' do
          it 'returns a correct status code' do
            put "/api/v1/meals/#{my_meal.id}", { meal: meal_params }, @headers

            expect(response).to be_success
          end

          it 'does not create a new Meal in the database' do
            my_meal # Since my_meal is eagerly defined, it needs to be explicitly created

            expect {
              put "/api/v1/meals/#{my_meal.id}", { meal: meal_params }, @headers
            }.to_not change(Meal, :count)
          end

          it 'changes the meal recorded data' do
            put "/api/v1/meals/#{my_meal.id}", { meal: meal_params }, @headers

            expect(my_meal.reload.description).to eq('Modified description')
          end
        end

        context 'when wrong data is provided' do
          it 'returns an Unprocessable Entity status code' do
            meal_params[:calories] = -50

            post '/api/v1/meals', { meal: meal_params }, @headers

            expect(response.status).to eq(422)
          end

          it 'does not create a new Meal' do
            meal_params[:calories] = -50

            expect {
              post '/api/v1/meals', { meal: meal_params }, @headers
            }.to_not change(Meal, :count)
          end
        end
      end

      context 'when user does not own the meal' do
        let(:not_my_meal) { create(:meal) }

        it 'raises Not Found exception' do
          expect {
            put "/api/v1/meals/#{not_my_meal.id}", { meal: meal_params }, @headers
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when User is not authenticated' do
      it 'returns Unauthorized status' do
        put "/api/v1/meals/#{my_meal.id}", { meal: meal_params }

        expect(response.status).to eq(401)
      end
    end
  end

  describe 'destroy' do
    let(:my_meal) { create(:meal, user_id: user.id, description: 'Original description') }

    context 'when user is authenticated' do
      before(:each) { login }

      context 'when user owns the meal' do
        it 'returns a correct status code' do
          delete "/api/v1/meals/#{my_meal.id}", {}, @headers

          expect(response).to be_success
        end

        it 'deletes the meal from the database' do
          my_meal # Since my_meal is eagerly defined, it needs to be explicitly created

          expect {
            delete "/api/v1/meals/#{my_meal.id}", {}, @headers
          }.to change(user.meals, :count).by(-1)
        end
      end

      context 'when user does not own the meal' do
        let(:not_my_meal) { create(:meal) }

        it 'raises Not Found exception' do
          expect {
            delete "/api/v1/meals/#{not_my_meal.id}", {}, @headers
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when User is not authenticated' do
      it 'returns Unauthorized status' do
        delete "/api/v1/meals/#{my_meal.id}", {}

        expect(response.status).to eq(401)
      end
    end
  end
end
