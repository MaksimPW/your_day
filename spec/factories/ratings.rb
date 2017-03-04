FactoryGirl.define do
  factory :rating do
    sequence(:value) { rand(0..10) }
    sequence(:day) { |n| (Date.new(2000,01,30) + n.days).to_s }
    user
  end
end
