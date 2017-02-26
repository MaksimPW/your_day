require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:day) }

  it { should belong_to(:user) }
end
