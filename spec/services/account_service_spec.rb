require 'rails_helper'

describe AccountService do
  describe 'when `account_id` is invalid' do
    let(:account_id) { 10 }

    it 'should render an error message' do
      balance = described_class.balance(account_id)

      expect(balance[:status]).to eq :error
      expect(balance[:message]).to eq 'Invalid account'
    end
  end

  describe 'when `account_id` is valid' do
    let(:account) { create(:account) }

    describe 'without `transactions`' do
      it 'should render a balance = 0' do
        balance = described_class.balance(account.id)

        expect(balance[:status]).to eq :ok
        expect(balance[:balance]).to eq 0
      end
    end

    describe 'with `transactions`' do
      before do
        create(:transaction, :debit, account: account, amount: 500.0)
        create(:transaction, :debit, account: account, amount: 500.0)
        create(:transaction, :credit, account: account, amount: 900.99)
        create(:transaction, :credit, account: account, amount: 1_000.00)
      end

      it 'should render a balance data' do
        balance = described_class.balance(account.id)

        expect(balance[:status]).to eq :ok
        expect(balance[:balance]).to eq 900.99
      end
    end
  end
end
