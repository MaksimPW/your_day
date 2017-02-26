class Rating < ApplicationRecord
  belongs_to :user

  validates :value, length: { in: 0..10 }, presence: :true
  validates :day, presence: :true
end
