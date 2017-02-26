class Rating < ApplicationRecord
  belongs_to :user

  validates :value, presence: true, inclusion: 0..10
  validates :day, presence: :true
end
