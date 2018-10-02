# frozen_string_literal: true

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

  describe '#to_h' do
    describe 'with an empty transaction' do
      it { expect(subject.to_h[:id]).to be_nil }
      it { expect(subject.to_h[:kind]).to be_nil }
      it { expect(subject.to_h[:amount]).to be_nil }
      it { expect(subject.to_h[:created]).to be_nil }
    end

    describe 'with a transaction' do
      let(:account) { create(:account) }

      subject { create(:transaction, :credit, amount: 100, account: account) }

      it { expect(subject.to_h[:id]).to_not be_nil }
      it { expect(subject.to_h[:kind]).to eq 'credit'}
      it { expect(subject.to_h[:amount]).to eq 100 }
      it { expect(subject.to_h[:created_at]).to_not be_nil }
    end
  end
end
