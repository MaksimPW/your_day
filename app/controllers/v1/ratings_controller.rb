class V1::RatingsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: {
        data: {
            message: "Welcome #{current_user.name}",
            user: current_user
        }
    }, status: 200
  end
end