require 'rails_helper'

RSpec.describe V1::RatingsController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #index' do
    context 'as Auth' do
      before { sign_in_api user }

      context 'with start_date and end_date' do
        let!(:ratings) { create_list(:rating, 5, user: user, day: Faker::Date.between('2017-02-01', '2017-02-05')) }

        it 'response ok' do
          get :index, params: { start_date: '2017-02-01', end_date: '2017-02-05' }, format: :json
          expect(response).to have_http_status(:ok)
        end

        it 'have array json size' do
          get :index, params: { start_date: '2017-02-01', end_date: '2017-02-05' }, format: :json
          expect(JSON.parse(response.body).size).to eq ratings.size
        end
      end

      context 'recent' do
        let!(:ratings) { create_list(:rating, 25, user: user, day: Faker::Date.between(30.days.ago, Date.today)) }
        let!(:other_ratings) { create_list(:rating, 2, user: user, day: Faker::Date.between(60.days.ago, 58.days.ago)) }

        it 'response ok' do
          get :index, format: :json
          expect(response).to have_http_status(:ok)
        end

        it 'have array json size' do
          get :index, format: :json
          expect(JSON.parse(response.body).size).to eq ratings.size
        end

        %w(id day value).each do |attr|
          it "have json attr #{attr}" do
            get :index, format: :json
            expect(response.body).to be_json_eql(ratings.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
          end
        end
      end
    end

    context 'as Guest' do
      it 'response unauthorized' do
        get :index, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    let!(:rating) { create(:rating, user: user) }

    context 'as Auth' do
      before { sign_in_api user }

      context 'by id' do
        before { get :show, params: { id: rating }, format: :json }

        it 'response ok' do
          expect(response).to have_http_status(:ok)
        end

        %w(id day value).each do |attr|
          it "have json attr #{attr}" do
            expect(response.body).to be_json_eql(rating.send(attr.to_sym).to_json).at_path(attr)
          end
        end
      end

      context 'by date' do
        before { get :show, params: { id: rating.day }, format: :json }

        it 'response ok' do
          expect(response).to have_http_status(:ok)
        end

        %w(id day value).each do |attr|
          it "have json attr #{attr}" do
            expect(response.body).to be_json_eql(rating.send(attr.to_sym).to_json).at_path(attr)
          end
        end
      end
    end

    context 'as Guest' do
      it 'response unauthorized' do
        get :show, params: { id: rating}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    context 'as Auth' do
      before { sign_in_api user }

      context 'with valid' do
        it 'change record count in the database' do
          expect { post :create, params: { rating: attributes_for(:rating) }, format: :json }.to change(Rating, :count).by(1)
        end

        it 'response ok' do
          post :create, params: { rating: attributes_for(:rating) }, format: :json
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid' do
        it 'not change record count in the database' do
          expect { post :create, params: { rating: { value: 422, day: DateTime.now.to_date } }, format: :json }.to_not change(Rating, :count)
        end

        it 'response unprocessable entity' do
          post :create, params: { rating: { value: 422, day: DateTime.now.to_date } }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'as Guest' do
      it 'response unauthorized' do
        post :create, params: { rating: attributes_for(:rating) }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:rating) { create(:rating, user: user) }

    context 'as Auth' do
      before { sign_in_api user }

      context 'with valid' do
        context 'by id' do
          it 'response ok' do
            patch :update, params: { id: rating, rating: { value: 10 } }, format: :json
            expect(response).to have_http_status(:ok)
          end
        end

        context 'by date' do
          it 'response ok' do
            patch :update, params: { id: rating.day, rating: { value: 10 } }, format: :json
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context 'with invalid' do
        it 'response unprocessable entity' do
          patch :update, params: { id: rating, rating: { value: 422 } }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'as Guest' do
      it 'response unauthorized' do
        patch :update, params: { id: rating, rating: { value: 10 } }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end