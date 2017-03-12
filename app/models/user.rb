class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
          omniauth_providers: [:github]
  include DeviseTokenAuth::Concerns::User
  has_many :ratings

  def author_of?(object)
    id == object.user_id
  end
end
