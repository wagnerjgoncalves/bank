class AccountService
  def self.balance(account_id)
    return {
      status: :error,
      message: 'Invalid account'
    } unless Account.exists?(account_id)

    transactions = Transaction.select('sum(amount) as total')
                              .where(account_id: account_id)
    debits = transactions.debit&.first&.total || 0
    credits = transactions.credit&.first&.total || 0

    {
      status: :ok,
      balance: credits - debits
    }
  end

  def self.has_money?(account_id, amount)
    response = balance(account_id)

    return true if response[:status] == :ok && response[:balance] >= amount

    false
  end
end
