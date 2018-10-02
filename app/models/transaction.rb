# frozen_string_literal: true

class Transaction < ApplicationRecord
  enum kind: { debit: 0, credit: 1 }

  belongs_to :account

  validates :account_id, :amount, :kind, presence: true
  validates :kind, inclusion: { in: Transaction.kinds.keys }
  validates :amount, numericality: { greater_than: 0, less_than: 1_000_000_000 }

  def to_h
    {
      id: id,
      kind: kind,
      created_at: created_at,
      amount: amount
    }
  end
end
