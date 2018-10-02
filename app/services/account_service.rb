# frozen_string_literal: true

class AccountService
  def self.balance(account_id)
    account = Account.find_by(id: account_id)

    return render_invalid_account_error unless account

    transactions = account.transactions.select('sum(amount) as total')
    debits = transactions.debit&.first&.total || 0
    credits = transactions.credit&.first&.total || 0

    {
      status: :ok,
      balance: credits - debits
    }
  end

  def self.enough_money?(account_id, amount)
    response = balance(account_id)

    return true if response[:status] == :ok && response[:balance] >= amount

    false
  end

  def self.statements(account_id)
    account = Account.find_by(id: account_id)

    return render_invalid_account_error unless account

    balance = 0

    statements = account.transactions.map do |transaction|
      if transaction.credit?
        balance += transaction.amount
      else
        balance -= transaction.amount
      end

      transaction.to_h.merge(balance: balance)
    end

    {
      status: :ok,
      data: statements
    }
  end

  class << self
    private

    def render_invalid_account_error
      {
        status: :error,
        message: 'Invalid account'
      }
    end
  end
end
