require 'rails_helper'

describe User do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :name }

    describe 'uniqueness' do
      describe '#email' do
        let!(:user) { create(:user) }

        subject { build(:user, email: user.email) }

        it { should validate_uniqueness_of(:email) }
      end
    end
  end
end
