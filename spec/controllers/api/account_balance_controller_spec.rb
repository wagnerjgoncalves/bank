# frozen_string_literal: true

require 'rails_helper'

describe API::AccountBalanceController do
  describe 'GET #show' do
    let(:json) { JSON.parse(response.body, symbolize_names: true) }

    describe 'with an invalid account' do
      before { get :show, params: { id: 1 } }

      it { expect(response.status).to eq 400 }

      it { expect(json[:message]).to eq 'Invalid account' }
    end

    describe 'with a valid account' do
      let!(:account) { create(:account) }

      before do
        create(:transaction, :credit, account: account, amount: 1.99)

        get :show, params: { id: account.id }
      end

      it { expect(response.status).to eq 200 }

      it { expect(json[:balance]).to eq 1.99 }
    end
  end
end
