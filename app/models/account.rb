# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user

  has_many :transactions

  validates :user_id, presence: true
end
