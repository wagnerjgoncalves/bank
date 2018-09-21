# frozen_string_literal: true

require 'rails_helper'

describe TransferService do
  let(:source_account) { create(:account) }
  let(:destination_account) { create(:account) }

  describe 'when `source_account_id` is invalid' do
    let(:source_account_id) { 10 }

    it 'should render an error message' do
      balance = described_class.transfer_money(source_account_id, nil, nil)

      expect(balance[:status]).to eq :error
      expect(balance[:message]).to eq 'Invalid `source` account'
    end
  end

  describe 'when `destination_account_id` is invalid' do
    let(:destination_account_id) { 10 }

    it 'should render an error message' do
      balance = described_class.transfer_money(source_account.id, destination_account_id, nil)

      expect(balance[:status]).to eq :error
      expect(balance[:message]).to eq 'Invalid `destination` account'
    end
  end

  describe 'when `amount` is invalid' do
    before do
      create(:transaction, :credit, account: source_account, amount: 500.0)
    end

    it 'should render an error message' do
      balance = described_class.transfer_money(source_account.id, destination_account.id, -1)

      expect(balance[:status]).to eq :error
      expect(balance[:message]).to eq 'Validation failed: Amount must be greater than 0'
    end
  end

  describe 'when `source_account` does not have enough money' do
    before do
      create(:transaction, :credit, account: source_account, amount: 500.0)
    end

    it 'should render an error message' do
      balance = described_class.transfer_money(source_account.id, destination_account.id, 600.0)

      expect(balance[:status]).to eq :error
      expect(balance[:message]).to eq 'Source account does not have enough money'
    end
  end

  describe 'when `source_account_id`, `destination_account_id` and `amount` are valid' do
    before do
      create(:transaction, :credit, account: source_account, amount: 500.0)
    end

    it 'should render a successful message' do
      balance = described_class.transfer_money(source_account.id, destination_account.id, 400.0)

      expect(balance[:status]).to eq :ok
      expect(balance[:message]).to eq 'Money transferred successfully'
    end
  end
end
