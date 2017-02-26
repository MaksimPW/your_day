require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:ratings) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:rating) { create(:rating, user: user) }

    it 'if current user is author of rating' do
      expect(user).to be_author_of(rating)
    end
  end
end
