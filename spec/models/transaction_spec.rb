require 'rails_helper'

describe Transaction do
  describe 'associations' do
    it { should belong_to :account }
  end

  describe 'validations' do
    it { should validate_presence_of :account_id }
    it { should validate_presence_of :amount }
    it { should validate_presence_of :kind }

    describe '#amount' do
     it { should validate_numericality_of(:amount).is_less_than(1_000_000_000) }
     it { should validate_numericality_of(:amount).is_greater_than(0) }
    end

    describe '#kind' do
      it { should allow_value('credit').for(:kind) }
      it { should allow_value('debit').for(:kind) }
    end
  end
end
