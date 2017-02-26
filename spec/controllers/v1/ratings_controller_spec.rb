require 'rails_helper'

RSpec.describe V1::RatingsController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #index' do
    let!(:ratings) { create_list(:rating, 2, user: user) }

    context 'as Auth' do
      before do
        sign_in_api user
        get :index, format: :json
      end

      it 'response ok' do
        expect(response).to have_http_status(:ok)
      end

      %w(id day value).each do |attr|
        it "have json attr #{attr}" do
          expect(response.body).to be_json_eql(ratings.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
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
      before do
        sign_in_api user
        get :show, params: { id: rating }, format: :json
      end

      it 'response ok' do
        expect(response).to have_http_status(:ok)
      end

      %w(id day value).each do |attr|
        it "have json attr #{attr}" do
          expect(response.body).to be_json_eql(rating.send(attr.to_sym).to_json).at_path(attr)
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
        it 'response ok' do
          patch :update, params: { id: rating, rating: { value: 10 } }, format: :json
          expect(response).to have_http_status(:ok)
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