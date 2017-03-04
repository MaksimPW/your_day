class Rating < ApplicationRecord
  belongs_to :user

  validates :value, presence: true, inclusion: 0..10
  validates :day, presence: true, uniqueness: {scope: :user_id}

  scope :recent, -> { where(['day > ?', 30.days.ago]) }
end
