# frozen_string_literal: true

class TransferService
  def self.transfer_money(source_account_id, destination_account_id, amount)
    return render_source_account_error unless Account.exists?(source_account_id)

    unless Account.exists?(destination_account_id)
      return render_destination_account_error
    end

    return render_accounts_error if source_account_id == destination_account_id

    unless AccountService.enough_money?(source_account_id, amount)
      return render_without_money_error
    end

    ActiveRecord::Base.transaction do
      begin
        create_transactions!(source_account_id, destination_account_id, amount)
      rescue ActiveRecord::RecordInvalid => e
        render_error e.message
      end
    end
  end

  class << self
    private

    def create_transactions!(src_account_id, dest_account_id, amount)
      opts_src = { account_id: src_account_id, kind: :debit, amount: amount }
      opts_des = { account_id: dest_account_id, kind: :credit, amount: amount }

      Transaction.create!(opts_src)
      Transaction.create!(opts_des)

      render_transfer_money_successfuly
    end

    def render_error(message)
      {
        status: :error,
        message: message
      }
    end

    def render_accounts_error
      render_error 'Cannot transfer money to the same account'
    end

    def render_destination_account_error
      render_error 'Invalid `destination` account'
    end

    def render_source_account_error
      render_error 'Invalid `source` account'
    end

    def render_transfer_money_successfuly
      {
        status: :ok,
        message: 'Money transferred successfully'
      }
    end

    def render_without_money_error
      render_error 'Source account does not have enough money'
    end
  end
end
