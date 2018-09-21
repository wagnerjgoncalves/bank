class TransferService
  def self.transfer_money(source_account_id, destination_account_id, amount)
    return render_source_account_error unless Account.exists?(source_account_id)
    return render_destination_account_error unless Account.exists?(destination_account_id)
    return render_without_money_error unless AccountService.has_money?(source_account_id, amount)

    ActiveRecord::Base.transaction do
      begin
        Transaction.create!(account_id: source_account_id, kind: :debit, amount: amount)
        Transaction.create!(account_id: destination_account_id, kind: :credit, amount: amount)

        render_transfer_money_successfuly
      rescue ActiveRecord::RecordInvalid => e
        render_error e.message
      end
    end
  end

  class << self
    def render_error(message)
      {
        status: :error,
        message: message
      }
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
