class AccountService
  def self.balance(account_id)
    return {
      status: :error,
      message: 'Invalid account'
    } unless Account.exists?(account_id)

    transactions = Transaction.where(account_id: account_id)
    debits = transactions.debit.collect(&:amount).reduce(:+) || 0
    credits = transactions.credit.collect(&:amount).reduce(:+) || 0
    balance = credits - debits

    {
      status: :ok,
      balance: balance
    }
  end
end
