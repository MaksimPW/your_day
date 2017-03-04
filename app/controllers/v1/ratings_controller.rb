class V1::RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rating, only: [:show, :update]

  def index
    @ratings =
        if params[:start_date].present? && params[:end_date].present?
          Rating.where(user: current_user, day: params[:start_date]..params[:end_date])
        else
          Rating.where(user: current_user).recent
        end
    render json: @ratings
  end

  def show
    authorize @rating
    render json: @rating
  end

  def create
    @rating = Rating.new(rating_params)
    @rating.user = current_user
    authorize @rating
    if @rating.save
      render json: @rating
    else
      render json: { errors: @rating.errors }, status: 422
    end
  end

  def update
    authorize @rating
    if @rating.update_attributes(rating_params)
      render json: @rating
    else
      render json: { errors: @rating.errors }, status: 422
    end
  end

  private
  def set_rating
    if params[:id].include?('-') #hardcode
      @rating = Rating.find_by(day: params[:id].to_date, user: current_user)
    else
      @rating = Rating.find(params[:id])
    end
  end

  def rating_params
    params.require(:rating).permit(:day, :value)
  end
end