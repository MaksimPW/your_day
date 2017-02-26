class V1::RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rating, only: [:show, :update]

  def index
    @ratings = Rating.where(user: current_user)
    render json: @ratings
  end

  def show
    render json: @rating
  end

  def create
    @rating = Rating.new(rating_params)
    @rating.user = current_user
    if @rating.save
      render json: @rating
    else
      render json: { errors: @rating.errors }, status: 422
    end
  end

  def update
    if @rating.update_attributes(rating_params)
      render json: @rating
    else
      render json: { errors: @rating.errors }, status: 422
    end
  end

  private
  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params.require(:rating).permit(:day, :value)
  end
end