class User < ApplicationRecord
  has_many :accounts

  validates :email, :name, presence: true
  validates :email, uniqueness: true
end
