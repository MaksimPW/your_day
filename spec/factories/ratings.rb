FactoryGirl.define do
  factory :rating do
    sequence(:value) { rand(0..10) }
    sequence(:day) { |n| (Date.new(2000,01,30) + n.days).to_s }
    user
  end

  trait :date_offset do
    transient do
      day_offset 0
    end

    sequence(:day) { |n| (day_offset.to_date - 1.day + n.days).to_s }
  end
end