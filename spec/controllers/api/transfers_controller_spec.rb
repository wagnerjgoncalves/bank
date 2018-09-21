# frozen_string_literal: true

require 'rails_helper'

describe API::TransfersController do
  describe 'POST #create' do
    let(:json) { JSON.parse(response.body, symbolize_names: true) }

    describe 'with an invalid `source` parameter' do
      before { post :create, params: { source_account_id: 1 } }

      it { expect(response.status).to eq 400 }
    end

    describe 'with an invalid `destination` parameter' do
      let!(:source_account) { create(:account) }
      let(:params) do
        {
          source_account_id: source_account.id,
          destination_account_id: 33
        }
      end

      before { post :create, params: params }

      it { expect(response.status).to eq 400 }
    end

    describe 'with an invalid `amount` parameter' do
      let(:source_account) { create(:account) }
      let(:destination_account) { create(:account) }
      let(:params) do
        {
          source_account_id: source_account.id,
          destination_account_id: destination_account.id,
          amount: 'XXX'
        }
      end

      before { post :create, params: params }

      it { expect(response.status).to eq 400 }
    end

    describe 'with an invalid parameters' do
      before { post :create, params: { source_account_id: 1 } }

      it { expect(response.status).to eq 400 }

      it { expect(json[:message]).to eq 'Invalid `source` account' }
    end

    describe 'with a valid parameters' do
      let(:source_account) { create(:account) }
      let(:destination_account) { create(:account) }
      let(:params) do
        {
          source_account_id: source_account.id,
          destination_account_id: destination_account.id,
          amount: 50.55
        }
      end

      before do
        create(:transaction, :credit, account: source_account, amount: 51.00)

        post :create, params: params
      end

      it { expect(response.status).to eq 200 }

      it { expect(json[:message]).to eq 'Money transferred successfully' }
    end
  end
end
