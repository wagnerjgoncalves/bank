# frozen_string_literal: true

require 'rails_helper'

describe AccountService do
  describe '.balance' do
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

  describe '.enough_money?' do
    let(:account) { create(:account) }

    before do
      create(:transaction, :credit, account: account, amount: 1_000.00)
    end

    it 'should render `true` when balance is <= amount' do
      enough_money = described_class.enough_money?(account.id, 999.99)

      expect(enough_money).to eq true
    end

    it 'should render `false` when balance is > amount' do
      enough_money = described_class.enough_money?(account.id, 1_000.01)

      expect(enough_money).to eq false
    end
  end

  describe '.statements' do
    describe 'when `account_id` is not valid' do
      let(:account_id) { 1 }

      subject { described_class.statements(account_id) }

      it 'should render an error message' do
        expect(subject[:status]).to eq :error
        expect(subject[:message]).to eq 'Invalid account'
      end
    end

    describe 'when account does not have transactions' do
      let(:account) { create(:account) }

      subject { described_class.statements(account.id) }

      it 'should render an empty data' do
        expect(subject[:status]).to eq :ok
        expect(subject[:data]).to be_empty
      end
    end

    describe 'when account have transactions' do
      let(:account) { create(:account) }

      before do
        create(:transaction, :credit, amount: 10, account: account)
        create(:transaction, :debit, amount: 5, account: account)
        create(:transaction, :credit, amount: 7, account: account)
      end

      subject { described_class.statements(account.id) }

      it 'should render the statements by transaction' do
        expect(subject[:status]).to eq :ok

        first_statement = subject[:data][0]
        second_statement = subject[:data][1]
        third_statement = subject[:data][2]

        expect(first_statement[:kind]).to eq 'credit'
        expect(first_statement[:amount]).to eq 10
        expect(first_statement[:balance]).to eq 10

        expect(second_statement[:kind]).to eq 'debit'
        expect(second_statement[:amount]).to eq 5
        expect(second_statement[:balance]).to eq 5

        expect(third_statement[:kind]).to eq 'credit'
        expect(third_statement[:amount]).to eq 7
        expect(third_statement[:balance]).to eq 12
      end
    end
  end
end
